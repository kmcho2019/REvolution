module TopModule (
    input clk,
    input in,
    output out
);
    reg ff_out;
    wire d_input;

    assign d_input = in ^ ff_out;
    assign out = ff_out;

    always @(posedge clk) begin
        ff_out <= d_input;
    end
endmodule