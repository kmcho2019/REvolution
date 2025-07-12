module synchronizer (
    input         clk_a,        // Clock signal A
    input         clk_b,        // Clock signal B
    input         arstn,        // Active-low reset signal A
    input         brstn,        // Active-low reset signal B
    input  [3:0]   data_in,      // Input data signal
    input         data_en,      // Input enable signal
    output [3:0]   dataout       // Output data signal
);

// Data Register
reg [3:0] data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else begin
        if (data_en) begin
            data_reg <= data_in;
        end
    end
end

// Enable Data Register
reg en_data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 1'd0;
    end else begin
        en_data_reg <= data_en;
    end
end

// Enable Control Registers
reg en_clap_one;
reg en_clap_two;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'd0;
        en_clap_two <= 1'd0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output Assignment
reg [3:0] dataout_reg;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout_reg <= 4'd0;
    end else if (en_clap_two) begin
        dataout_reg <= data_reg;
    end
end

assign dataout = dataout_reg;

endmodule