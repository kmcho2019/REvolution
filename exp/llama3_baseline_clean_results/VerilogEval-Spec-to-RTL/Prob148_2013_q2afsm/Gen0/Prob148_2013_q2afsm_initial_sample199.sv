module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// State table
always @(*) begin
    case (state)
        2'b00: // State A
            if (~r[0] && ~r[1] && ~r[2]) 
                next_state = 2'b00;
            else if (r[0]) 
                next_state = 2'b01;
            else if (r[1]) 
                next_state = 2'b10;
            else if (r[2]) 
                next_state = 2'b11;
        2'b01: // State B
            if (r[0]) 
                next_state = 2'b01;
            else 
                next_state = 2'b00;
        2'b10: // State C
            if (r[1]) 
                next_state = 2'b10;
            else 
                next_state = 2'b00;
        2'b11: // State D
            if (r[2]) 
                next_state = 2'b11;
            else 
                next_state = 2'b00;
        default: 
            next_state = 2'b00;
    endcase
end

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

// State flip-flops
always @(posedge clk) begin
    if (~resetn) 
        state <= 2'b00;
    else 
        state <= next_state;
end

endmodule