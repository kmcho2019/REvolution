module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] hdc; // High-Duration Counter
reg [1:0] ldc; // Low-Duration Counter
reg prev_data_in; // Previous value of data_in

always @(posedge clk) begin
    if (!rst_n) begin
        hdc <= 0;
        ldc <= 0;
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        if (data_in) begin
            // Input signal is high
            hdc <= hdc + 1; // Increment HDC
            ldc <= 0; // Reset LDC
            if (prev_data_in == 0 && hdc == 1) begin
                // Pulse detected: previous value was low, and HDC threshold met
                data_out <= 1;
            end else begin
                data_out <= 0;
            end
        end else begin
            // Input signal is low
            ldc <= ldc + 1; // Increment LDC
            hdc <= 0; // Reset HDC
            if (prev_data_in == 1 && ldc == 1) begin
                // Pulse detected: previous value was high, and LDC threshold met
                data_out <= 1;
            end else begin
                data_out <= 0;
            end
        end
        prev_data_in <= data_in; // Update previous value of data_in
    end
end

endmodule