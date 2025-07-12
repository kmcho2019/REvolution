module TopModule (
    input clk,
    input in,
    output reg out
);

    reg prev_out;
    wire xor_result;

    assign xor_result = in ^ prev_out;

    always @(posedge clk) begin
        prev_out <= out;
        out <= xor_result;
    end

endmodule