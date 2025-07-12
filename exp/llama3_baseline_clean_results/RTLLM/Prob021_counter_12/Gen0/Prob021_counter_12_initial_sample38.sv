module counter_12(
    input logic rst_n,
    input logic clk,
    input logic valid_count,
    output logic [3:0] out
);

always_ff @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000; // reset to 0 when rst_n is active low
    end else if (valid_count) begin
        if (out == 4'd11) begin
            out <= 4'b0000; // wrap around to 0 when maximum count is reached
        end else begin
            out <= out + 1; // increment the counter
        end
    end
end

endmodule