module synchronizer(
    input clk_a,    // Clock signal A
    input clk_b,    // Clock signal B
    input arstn,    // Active-low reset signal A
    input brstn,    // Active-low reset signal B
    input [3:0] data_in,  // Input data signal
    input data_en,    // Input enable signal
    output [3:0] dataout  // Output data signal
);

reg [3:0] data_reg;  // Data register
reg data_en_reg;     // Enable data register
reg en_clap_one;     // First control register
reg en_clap_two;     // Second control register

// Update data register and enable data register
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
        data_en_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        data_en_reg <= data_en;
    end
end

// Update control registers
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= data_en_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
end

endmodule