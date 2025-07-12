module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00;  
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        2'b00:  
            if (r[0]) begin
                next_state = 2'b01;  
            end else if (r[1]) begin
                next_state = 2'b10;  
            end else if (r[2]) begin
                next_state = 2'b11;  
            end else begin
                next_state = 2'b00;  
            end
        2'b01:  
            next_state = r[0]? 2'b01 : 2'b00;
        2'b10:  
            next_state = r[1]? 2'b10 : 2'b00;
        2'b11:  
            next_state = r[2]? 2'b11 : 2'b00;
        default:
            next_state = 2'b00;  
    endcase
end

assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = (current_state == 2'b11);

// Add clock gating to reduce power consumption
reg clock_enable;
always @(*) begin
    clock_enable = (current_state!= 2'b00) || (r[0] || r[1] || r[2]);
end

// Use clock gating to disable the clock signal when not active
wire gated_clk;
assign gated_clk = clock_enable? clk : 1'b0;

// Replace the original clock signal with the gated clock signal
always @(posedge gated_clk) begin
    if (~resetn) begin
        current_state <= 2'b00;  
    end else begin
        current_state <= next_state;
    end
end

endmodule