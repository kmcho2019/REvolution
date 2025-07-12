module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Synchronization wires
    wire en_sync1, en_sync2;
    
    // First stage sync register
    reg en_sync1_reg;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            en_sync1_reg <= 1'b0;
        else
            en_sync1_reg <= data_en;
    end
    assign en_sync1 = en_sync1_reg;
    
    // Second stage sync register
    reg en_sync2_reg;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            en_sync2_reg <= 1'b0;
        else
            en_sync2_reg <= en_sync1;
    end
    assign en_sync2 = en_sync2_reg;
    
    // Output data assignment
    wire [3:0] next_dataout = en_sync2 ? data_in : dataout;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else
            dataout <= next_dataout;
    end

endmodule