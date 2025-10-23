module counter_12 (
    input  logic       rst_n,
    input  logic       clk,
    input  logic       valid_count,
    output logic [3:0] out
);

always_ff @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000; // Reset counter to 0 when reset signal is active low
    end else if (valid_count) begin
        if (out == 4'd11) begin
            out <= 4'b0000; // Wrap around to 0 when counter reaches maximum value
        end else begin
            out <= out + 1; // Increment counter by 1
        end
    end
end

endmodule