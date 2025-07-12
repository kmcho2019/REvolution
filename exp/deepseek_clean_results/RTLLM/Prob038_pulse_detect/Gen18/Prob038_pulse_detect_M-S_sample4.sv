module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg seen_rise;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        seen_rise <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Track if we've seen a rising edge
        if (!seen_rise && !data_in) begin
            seen_rise <= 1'b0;  // Wait for 0->1
        end else begin
            seen_rise <= data_in;
        end

        // Output pulse on falling edge after rise
        data_out <= seen_rise && !data_in;
    end
end

endmodule