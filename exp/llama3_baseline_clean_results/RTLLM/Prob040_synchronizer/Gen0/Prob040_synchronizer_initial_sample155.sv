module synchronizer (
    input clk_a, // Clock signal A
    input clk_b, // Clock signal B
    input arstn, // Active-low reset signal A
    input brstn, // Active-low reset signal B
    input [3:0] data_in, // Input data signal of size 4 bits
    input data_en, // Input enable signal
    output reg [3:0] dataout // Output data signal of size 4 bits
);

reg [3:0] data_reg; // Register to store the input data signal
reg en_data_reg; // Register to store the input enable signal
reg en_clap_one; // Register to control the selection of the input data
reg en_clap_two; // Register to control the selection of the input data

// Update data_reg and en_data_reg on the positive edge of clk_a or the falling edge of arstn
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Update en_clap_one and en_clap_two on the positive edge of clk_b or the falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Assign output data value on the positive edge of clk_b or the falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
end

endmodule