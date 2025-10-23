module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg; // Data register clocked by clk_b
reg request_sync; // Synchronized request signal
reg en_data_reg; // Register for data_en
reg en_clap_one; // First enable control register
reg en_clap_two; // Second enable control register

// Combinational logic for request signal generation
assign request_sync = data_en;

// Sequential logic for data capture and output assignment
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'd0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Enable control registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'd0;
        en_clap_two <= 1'd0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
end

endmodule