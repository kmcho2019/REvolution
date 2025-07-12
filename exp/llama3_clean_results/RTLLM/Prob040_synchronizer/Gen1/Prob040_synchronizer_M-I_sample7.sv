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
reg       clk_a_gated;    // Gated clock signal A
reg       clk_b_gated;    // Gated clock signal B

// Clock gating
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        clk_a_gated <= 1'b0;
    end else if (data_en) begin
        clk_a_gated <= 1'b1;
    end else begin
        clk_a_gated <= 1'b0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        clk_b_gated <= 1'b0;
    end else if (en_clap_two) begin
        clk_b_gated <= 1'b1;
    end else begin
        clk_b_gated <= 1'b0;
    end
end

// Update data register and enable data register on gated clk_a
always @(posedge clk_a_gated or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Update enable control registers on gated clk_b
always @(posedge clk_b_gated or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Assign output data on gated clk_b
always @(posedge clk_b_gated or negedge brstn) begin
    if (~brstn) begin
        dataout_reg <= 4'b0;
    end else if (en_clap_two) begin
        dataout_reg <= data_reg;
    end
end

// Continuous assignment for output
assign dataout = dataout_reg;

endmodule