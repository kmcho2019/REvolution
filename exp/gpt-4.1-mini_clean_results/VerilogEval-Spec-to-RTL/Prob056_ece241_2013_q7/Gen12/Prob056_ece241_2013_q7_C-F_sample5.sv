module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

    // Compute next state of JK flip-flop using characteristic equation:
    // Q_next = J·Q' + K'·Q
    wire nextQ = (j & ~Q) | (~k & Q);

    // Update output Q on positive clock edge
    always @(posedge clk) begin
        Q <= nextQ;
    end

endmodule