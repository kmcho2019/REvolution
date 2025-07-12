module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] state;
reg [1:0] next_state;

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        2'b00: begin
            if (r[0]) next_state = 2'b01;
            else if (r[1]) next_state = 2'b10;
            else if (r[2]) next_state = 2'b11;
        end
        2'b01: if (!r[0]) next_state = 2'b00;
        2'b10: if (!r[1]) next_state = 2'b00;
        2'b11: if (!r[2]) next_state = 2'b00;
    endcase
end

// State register
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;  // Reset to state A
    else state <= next_state;
end

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule