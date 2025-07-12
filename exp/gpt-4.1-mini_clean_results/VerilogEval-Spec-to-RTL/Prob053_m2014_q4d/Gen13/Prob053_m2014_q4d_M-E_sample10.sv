module TopModule (
    input clk,
    input in,
    output out
);

    reg q_reg;
    reg next_out;

    always @(*) begin
        next_out = in ^ q_reg;
    end

    always @(posedge clk) begin
        q_reg <= next_out;
    end

    assign out = q_reg;

endmodule