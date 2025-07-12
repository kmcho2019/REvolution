module TopModule(
    input clk,
    input d,
    output reg q
);

    reg gated_clk;
    reg q_int;

    // Simple clock gating: gate the clock only if d != q_int
    always @(*) begin
        gated_clk = clk & (d != q_int);
    end

    always @(posedge gated_clk) begin
        q_int <= d;
    end

    always @(posedge clk) begin
        q <= q_int;
    end

endmodule