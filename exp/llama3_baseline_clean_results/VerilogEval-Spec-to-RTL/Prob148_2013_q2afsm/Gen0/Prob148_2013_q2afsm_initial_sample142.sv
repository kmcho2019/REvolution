module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state
reg [1:0] cs;

// Next state
reg [1:0] ns;

// Output signals
assign g[0] = (cs == B);
assign g[1] = (cs == C);
assign g[2] = 1'b0; // This is not specified in the state diagram, but since there's no state that sets g[2] to 1, we assume it's always 0.

// Next state logic
always @(*)
begin
    case(cs)
        A: 
            if (r[0] == 1'b1) 
                ns = B;
            else if (r[1] == 1'b1) 
                ns = C;
            else if (r[2] == 1'b1) 
                ns = D;
            else 
                ns = A;
        B: 
            if (r[0] == 1'b1) 
                ns = B;
            else 
                ns = A;
        C: 
            if (r[1] == 1'b1) 
                ns = C;
            else 
                ns = A;
        D: 
            // Since there is no condition to leave state D, we assume it's a sink state.
            // However, based on the diagram, it should behave like state A.
            if (r[0] == 1'b1) 
                ns = B;
            else if (r[1] == 1'b1) 
                ns = C;
            else if (r[2] == 1'b1) 
                ns = D;
            else 
                ns = A;
        default: ns = A;
    endcase
end

// State flip-flop
always @(posedge clk)
begin
    if (~resetn) 
        cs <= A;
    else 
        cs <= ns;
end

endmodule