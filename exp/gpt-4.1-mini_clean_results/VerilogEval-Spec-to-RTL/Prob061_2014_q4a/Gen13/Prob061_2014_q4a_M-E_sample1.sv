module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire nextQ;
    assign nextQ = L ? R : (E ? w : Q);

    always @(posedge clk) begin
        Q <= nextQ;
    end

endmodule