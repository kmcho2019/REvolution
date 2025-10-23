module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    // Next-state logic separated for clarity and maintainability
    wire nextQ = L ? R :
                 E ? w :
                 Q;

    // Sequential update on positive clock edge
    always @(posedge clk) begin
        Q <= nextQ;
    end

endmodule