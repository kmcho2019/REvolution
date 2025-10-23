module counter_12(
    input logic rst_n,
    input logic clk,
    input logic valid_count,
    output logic [3:0] out
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;  // Reset counter to 0 when rst_n is 0
    end else if (valid_count) begin
        out <= (out == 4'd11) ? 4'b0000 : out + 1;  // Simplified conditional statement
    end
end

endmodule