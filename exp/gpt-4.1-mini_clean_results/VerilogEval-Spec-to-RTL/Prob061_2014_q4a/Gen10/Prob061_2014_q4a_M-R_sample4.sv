module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire next_Q;

    // Combinational next state logic as a continuous assignment with priority encoding
    assign next_Q = L ? R : (E ? w : Q);

    // Sequential state update on positive clock edge
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule