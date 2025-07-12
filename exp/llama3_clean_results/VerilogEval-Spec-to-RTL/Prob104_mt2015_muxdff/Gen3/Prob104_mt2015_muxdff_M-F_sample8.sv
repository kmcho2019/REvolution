module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    reg internal_Q;
    assign Q = internal_Q;

    always @(posedge clk) begin
        if (L) begin
            internal_Q <= r_in;
        end else begin
            internal_Q <= q_in;
        end
    end

endmodule