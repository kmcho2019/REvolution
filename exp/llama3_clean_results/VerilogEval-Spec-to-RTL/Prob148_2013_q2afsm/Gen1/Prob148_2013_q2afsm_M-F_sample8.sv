module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] state;
reg [1:0] next_state;

// Continuous assignment for output signals
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

// Next state logic
always @(*)
begin
    case (state)
        2'b00:  // State A
            if (~r[2] && ~r[1] && ~r[0])
                next_state = 2'b00;  // Stay in A if no requests
            else if (r[0])
                next_state = 2'b01;  // Go to B if r0 is 1
            else if (r[1])
                next_state = 2'b10;  // Go to C if r1 is 1
            else
                next_state = 2'b11;  // Go to D if only r2 is 1
        2'b01:  // State B
            if (r[0])
                next_state = 2'b01;  // Stay in B if r0 is 1
            else
                next_state = 2'b00;  // Go to A if r0 is 0
        2'b10:  // State C
            if (r[1])
                next_state = 2'b10;  // Stay in C if r1 is 1
            else
                next_state = 2'b00;  // Go to A if r1 is 0
        2'b11:  // State D
            if (r[2])
                next_state = 2'b11;  // Stay in D if r2 is 1
            else
                next_state = 2'b00;  // Go to A if r2 is 0
        default:
            next_state = 2'b00;  // Default to state A
    endcase
end

// State register
always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00;  // Reset to state A
    else
        state <= next_state;
end

endmodule