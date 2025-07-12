module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire d;

    assign d = in ^ state;
    assign out = state;

    always @(posedge clk) begin
        state <= d;
    end

endmodule