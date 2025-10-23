module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] intermediate_sum;
reg [2*size-1:0] final_sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        intermediate_sum <= {2*size{1'b0}};
        final_sum <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        intermediate_sum <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                intermediate_sum <= intermediate_sum + (mul_a << i);
            end
        end
        final_sum <= intermediate_sum;
        mul_out <= final_sum;
    end
end

endmodule