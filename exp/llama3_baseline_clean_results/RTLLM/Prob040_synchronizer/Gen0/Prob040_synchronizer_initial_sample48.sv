module synchronizer(
    input  clk_a,        // Clock signal A
    input  clk_b,        // Clock signal B
    input  arstn,        // Active-low reset signal A
    input  brstn,        // Active-low reset signal B
    input  [3:0] data_in, // Input data signal
    input  data_en,      // Input enable signal
    output [3:0] dataout  // Output data signal
);

reg [3:0] data_reg;      // Register to store input data signal
reg en_data_reg;         // Register to store input enable signal
reg en_clap_one;         // First control register
reg en_clap_two;         // Second control register
reg [3:0] dataout_reg;   // Register to store output data signal

// Update data register and enable data register on positive edge of clk_a or falling edge of arstn
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Update enable control registers on positive edge of clk_b or falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Assign output data on positive edge of clk_b or falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout_reg <= 4'b0;
    end else if (en_clap_two) begin
        dataout_reg <= data_reg;
    end
end

// Assign output
assign dataout = dataout_reg;

endmodule