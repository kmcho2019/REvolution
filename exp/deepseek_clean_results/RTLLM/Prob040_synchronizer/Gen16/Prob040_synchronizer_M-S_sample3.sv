module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Two-stage synchronizer for enable in clk_b domain
    reg [1:0] en_sync;
    
    always @(posedge clk_b or negedge brstn)
        if (!brstn) en_sync <= 2'b0;
        else en_sync <= {en_sync[0], data_en};

    // Output assignment
    always @(posedge clk_b or negedge brstn)
        if (!brstn) dataout <= 4'b0;
        else if (en_sync[1]) dataout <= data_in;

endmodule