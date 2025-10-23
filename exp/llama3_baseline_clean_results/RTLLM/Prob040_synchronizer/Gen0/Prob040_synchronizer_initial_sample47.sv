module synchronizer (
    input  wire            clk_a,         // Clock signal A
    input  wire            clk_b,         // Clock signal B
    input  wire            arstn,         // Active-low reset signal A
    input  wire            brstn,         // Active-low reset signal B
    input  wire [3:0]      data_in,       // Input data signal
    input  wire            data_en,       // Input enable signal
    output reg  [3:0]      dataout        // Output data signal
);

reg [3:0] data_reg;         // Register to store input data signal
reg       en_data_reg;      // Register to store input enable signal
reg       en_clap_one;      // First control register
reg       en_clap_two;      // Second control register

// Update data register and enable data register on the positive edge of clk_a
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Update control registers on the positive edge of clk_b
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
        dataout <= 4'd0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout <= data_reg;
        end
    end
end

endmodule