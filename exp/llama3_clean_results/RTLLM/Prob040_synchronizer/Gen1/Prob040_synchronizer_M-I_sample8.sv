module synchronizer(
    input               clk_a,    // Clock signal A
    input               clk_b,    // Clock signal B
    input               arstn,    // Active-low reset signal A
    input               brstn,    // Active-low reset signal B
    input   [3:0]       data_in,  // Input data signal
    input               data_en,  // Input enable signal
    output  [3:0]       dataout   // Output data signal
);

reg [3:0] data_reg;      // Data register
reg       en_data_reg;   // Enable data register
reg       en_clap_one;   // First enable control register
reg       en_clap_two;   // Second enable control register
reg [3:0] dataout_reg;   // Output data register

// Update data register and enable data register on clk_a or reset
always @(posedge clk_a) begin
    if (~arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Update enable control registers on clk_b or reset
always @(posedge clk_b) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Assign output data on clk_b or reset
always @(posedge clk_b) begin
    if (~brstn) begin
        dataout_reg <= 4'b0;
    end else if (en_clap_two) begin
        dataout_reg <= data_reg;
    end
end

// Continuous assignment for output
assign dataout = dataout_reg;

endmodule