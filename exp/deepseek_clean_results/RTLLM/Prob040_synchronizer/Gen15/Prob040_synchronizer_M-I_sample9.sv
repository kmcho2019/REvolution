module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg en_reg;
    
    // Clock domain B registers
    reg en_sync1, en_sync2;
    reg [3:0] data_sync;
    
    // Clock domain A: capture input data and enable
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_reg <= data_en;
        end
    end
    
    // Clock domain B: two-stage enable synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_reg;
            en_sync2 <= en_sync1;
        end
    end
    
    // Clock domain B: data capture and output
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_sync <= 4'b0;
            dataout <= 4'b0;
        end else begin
            if (en_sync1) begin
                data_sync <= data_reg;
            end
            if (en_sync2) begin
                dataout <= data_sync;
            end
        end
    end

endmodule