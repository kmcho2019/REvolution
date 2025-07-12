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
always @(*)
begin
    case (state)
        2'b00:  // State A
            if (r[0])
                next_state = 2'b01;  // Go to B if r0 is 1
            else if (r[1])
                next_state = 2'b10;  // Go to C if r1 is 1
            else if (r[2])
                next_state = 2'b11;  // Go to D if r2 is 1
            else
                next_state = 2'b00;  // Stay in A if no requests
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

// Output logic
always @(posedge clk)
begin
    case (state)
        2'b00:  // State A
            g <= 3'b000;
        2'b01:  // State B
            g <= 3'b100;
        2'b10:  // State C
            g <= 3'b010;
        2'b11:  // State D
            g <= 3'b001;
        default:
            g <= 3'b000;  // Default to output 0
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