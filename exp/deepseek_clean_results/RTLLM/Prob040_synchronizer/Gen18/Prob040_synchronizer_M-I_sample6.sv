module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Register input data in clk_a domain
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn)
        if (!arstn) data_reg <= 4'b0;
        else data_reg <= data_in;

    // Two-stage synchronizer with shared reset
    reg [1:0] en_sync;
    wire sync_reset = !brstn;
    
    always @(posedge clk_b or posedge sync_reset)
        if (sync_reset) en_sync <= 2'b0;
        else en_sync <= {en_sync[0], data_en};

    // Clock-gated output register
    wire output_clken = en_sync[1];
    
    always @(posedge clk_b or negedge brstn)
        if (!brstn) dataout <= 4'b0;
        else if (output_clken) dataout <= data_reg;

endmodule