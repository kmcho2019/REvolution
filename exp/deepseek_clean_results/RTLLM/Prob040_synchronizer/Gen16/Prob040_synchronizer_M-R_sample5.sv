module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Enable register in clk_a domain
    reg en_a;
    assign en_a = !arstn ? 1'b0 : data_en;

    // Two-stage synchronizer in clk_b domain
    reg [1:0] en_sync;
    assign en_sync[0] = !brstn ? 1'b0 : en_a;
    assign en_sync[1] = !brstn ? 1'b0 : en_sync[0];

    // Output register (must remain sequential)
    always @(posedge clk_b or negedge brstn)
        dataout <= !brstn ? 4'b0 : (en_sync[1] ? data_in : dataout);

endmodule