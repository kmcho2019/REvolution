module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire xor_in;

    assign xor_in = in ^ state;

    always @(posedge clk) begin
        state <= xor_in;
    end

    assign out = state;

endmodule