module synchronizer (
    input        clk_a,      // Clock signal A used for synchronous operations.
    input        clk_b,      // Clock signal B used for synchronous operations.
    input        arstn,      // Active-low reset signal A. Defined as 0 for reset and 1 for reset signal inactive.
    input        brstn,      // Active-low reset signal B. Defined as 0 for reset and 1 for reset signal inactive.
    input  [3:0] data_in,    // Input data signal of size 4 bits.
    input        data_en,    // Input enable signal that controls the selection operation.
    output [3:0] dataout     // Output data signal of size 4 bits.
);

reg [3:0] data_reg;          // Register to store the input data signal.
reg        en_data_reg;      // Register to store the input enable signal.
reg        en_clap_one;      // First enable control register.
reg        en_clap_two;      // Second enable control register.
reg [3:0] dataout_reg;       // Register to store the output data value.

// Data Register and Enable Data Register
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Enable Control Registers
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output Assignment
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout_reg <= 4'b0;
    end else if (en_clap_two) begin
        dataout_reg <= data_reg;
    end else begin
        dataout_reg <= dataout_reg;
    end
end

// Assign output
assign dataout = dataout_reg;

endmodule