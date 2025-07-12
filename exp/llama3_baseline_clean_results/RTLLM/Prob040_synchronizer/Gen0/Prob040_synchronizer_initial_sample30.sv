module synchronizer(
    input        clk_a,       // Clock signal A used for synchronous operations
    input        clk_b,       // Clock signal B used for synchronous operations
    input        arstn,       // Active-low reset signal A
    input        brstn,       // Active-low reset signal B
    input  [3:0] data_in,     // Input data signal of size 4 bits
    input        data_en,     // Input enable signal that controls the selection operation
    output [3:0] dataout      // Output data signal of size 4 bits
);

reg [3:0] data_reg;           // Data register
reg        en_data_reg;       // Enable data register
reg        en_clap_one;       // Enable control register one
reg        en_clap_two;       // Enable control register two

// Update data register and enable data register on the positive edge of clk_a or the falling edge of arstn
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg       <= 4'b0;
        en_data_reg    <= 1'b0;
    end else begin
        data_reg       <= data_in;
        en_data_reg    <= data_en;
    end
end

// Update enable control registers on the positive edge of clk_b or the falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one    <= 1'b0;
        en_clap_two    <= 1'b0;
    end else begin
        en_clap_one    <= en_data_reg;
        en_clap_two    <= en_clap_one;
    end
end

// Assign output data value on the positive edge of clk_b or the falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout        <= 4'b0;
    end else if (en_clap_two) begin
        dataout        <= data_reg;
    end
end

endmodule