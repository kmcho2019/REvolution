module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    reg q FF_Q;

    always @(posedge clk) begin
        if (L) begin
            FF_Q <= r_in;
        end else begin
            FF_Q <= q_in;
        end
    end

    assign Q = FF_Q;

endmodule