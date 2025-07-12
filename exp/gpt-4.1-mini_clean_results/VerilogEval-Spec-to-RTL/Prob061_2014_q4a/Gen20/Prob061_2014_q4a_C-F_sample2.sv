module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire next_Q;
    assign next_Q = L ? R : (E ? w : Q);

    wire enable = (next_Q != Q);

    always @(posedge clk) begin
        if (enable)
            Q <= next_Q;
        // else retain Q
    end

endmodule