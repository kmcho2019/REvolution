module synchronizer (
    input           clk_a,      // Clock signal A
    input           clk_b,      // Clock signal B
    input           arstn,      // Active-low reset signal A
    input           brstn,      // Active-low reset signal B
    input   [3:0]    data_in,    // Input data signal
    input           data_en,    // Input enable signal
    output  [3:0]    dataout     // Output data signal
);

reg [3:0] data_reg;            // Register to store the input data signal
reg       en_data_reg;          // Register to store the input enable signal
reg       en_clap_one;          // First control register to delay the enable signal
reg       en_clap_two;          // Second control register to delay the enable signal

always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg     <= 4'd0;       // Reset data register to 0
        en_data_reg  <= 1'd0;       // Reset enable register to 0
    end else begin
        data_reg     <= data_in;   // Update data register with input data
        en_data_reg  <= data_en;   // Update enable register with input enable
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one   <= 1'd0;      // Reset first control register to 0
        en_clap_two   <= 1'd0;      // Reset second control register to 0
        dataout      <= 4'd0;       // Reset output data to 0
    end else begin
        en_clap_one   <= en_data_reg;  // Update first control register with enable signal
        en_clap_two   <= en_clap_one;   // Update second control register with previous value of first control register
        if (en_clap_two) begin
            dataout  <= data_reg;     // Assign output data with data register if control signal is active
        end else begin
            // Retain previous output data value if control signal is inactive
        end
    end
end

endmodule