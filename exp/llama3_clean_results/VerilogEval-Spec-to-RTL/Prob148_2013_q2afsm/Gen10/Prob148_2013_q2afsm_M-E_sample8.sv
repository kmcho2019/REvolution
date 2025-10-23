module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define an enumeration for the states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Always block for the state register
always @(posedge clk) begin
    if (~resetn) state <= A;
    else state <= next_state;
end

// Continuous assignment for the next state logic
assign next_state = (state == A)? (r[0]? B : (r[1]? C : (r[2]? D : A))) :
                    (state == B)? (r[0]? B : A) :
                    (state == C)? (r[1]? C : A) :
                    (state == D)? (r[2]? D : A) : A;

// Continuous assignment for the output logic
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = (state == D);

endmodule