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
    reg en_reg_a;
    
    // Capture data and enable in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg_a <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_reg_a <= data_en;
        end
    end

    // Clock domain B synchronization registers
    reg en_sync1, en_sync2;
    
    // Two-stage synchronizer for enable signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_reg_a;
            en_sync2 <= en_sync1;
        end
    end

    // Output data register with conditional update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2) begin
            dataout <= data_reg;
        end
    end

endmodule