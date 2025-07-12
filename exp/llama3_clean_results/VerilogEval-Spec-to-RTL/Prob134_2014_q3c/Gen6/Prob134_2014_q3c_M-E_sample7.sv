module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [1:0] current_state_low;
reg [1:0] next_state_low;
reg current_state_high;
reg next_state_high;

// Combinational logic for next state
always @ (*) begin
    case (y)
        3'b000: begin
            next_state_low = (x)? 2'b01 : 2'b00;
            next_state_high = 1'b0;
        end
        3'b001: begin
            next_state_low = (x)? 2'b10 : 2'b01;
            next_state_high = 1'b0;
        end
        3'b010: begin
            next_state_low = (x)? 2'b01 : 2'b10;
            next_state_high = 1'b0;
        end
        3'b011: begin
            next_state_low = (x)? 2'b10 : 2'b01;
            next_state_high = 1'b0;
        end
        3'b100: begin
            next_state_low = 2'b10;
            next_state_high = (x)? 1'b0 : 1'b1;
        end
        default: begin
            next_state_low = 2'b00;
            next_state_high = 1'b0;
        end
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    current_state_low <= next_state_low;
    current_state_high <= next_state_high;
end

// Output logic
always @ (*) begin
    if (y == 3'b011 || y == 3'b100) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

assign Y0 = next_state_low[0];

endmodule