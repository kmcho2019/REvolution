module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A: Capture stable input when enabled
    reg [3:0] stable_data;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            stable_data <= 4'b0;
        end else if (data_en) begin
            stable_data <= data_in;
        end
    end

    // Clock domain B: 2-stage enable synchronizer
    reg [1:0] en_sync;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
            dataout <= 4'b0;
        end else begin
            en_sync <= {en_sync[0], data_en};
            if (en_sync[1]) begin
                dataout <= stable_data;
            end
        end
    end

endmodule