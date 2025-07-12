module TopModule (
    input clk,
    input in,
    output out
);

    reg state;

    wire d_in = in ^ state;

    always @(posedge clk) begin
        state <= d_in;
    end

    assign out = state;

endmodule