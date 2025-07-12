module counter_12(
    input logic rst_n,
    input logic clk,
    input logic valid_count,
    output logic [3:0] out
);

logic [3:0] next_out;

assign next_out = (out == 4'd11) ? 4'b0000 : (valid_count ? out + 1 : out);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;  // Reset counter to 0 when rst_n is 0
    end else begin
        out <= next_out;  // Update counter based on next state
    end
end

endmodule