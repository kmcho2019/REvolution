module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data capture in clk_a domain
    reg [3:0] data_reg;
    reg data_en_prev;
    wire en_rise;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            data_en_prev <= 1'b0;
        end else begin
            data_reg <= data_in;
            data_en_prev <= data_en;
        end
    end

    // Edge detection in clk_a domain
    assign en_rise = data_en && !data_en_prev;

    // Pulse generation and 3-stage synchronizer in clk_b domain
    reg [2:0] en_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 3'b0;
        end else begin
            en_sync <= {en_sync[1:0], en_rise};
        end
    end

    // Output data register with edge-triggered update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync[2] && !en_sync[1]) begin  // Detect sync'd pulse
            dataout <= data_reg;
        end
    end

endmodule