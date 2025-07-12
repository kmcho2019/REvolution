module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire xor_in;

    assign xor_in = in ^ state;
    assign out = state;

    always @(posedge clk) begin
        state <= xor_in;
    end

endmodule