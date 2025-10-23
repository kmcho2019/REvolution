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
    reg [3:0] data_reg_a;
    reg en_reg_a;
    
    // Clock domain B signals
    wire en_sync1_b, en_sync2_b;
    reg [3:0] data_reg_b;
    
    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a <= 1'b0;
        end else begin
            data_reg_a <= data_in;
            en_reg_a <= data_en;
        end
    end

    // Two-stage synchronizer for enable signal
    reg en_sync1_b_reg, en_sync2_b_reg;
    
    assign en_sync1_b = en_sync1_b_reg;
    assign en_sync2_b = en_sync2_b_reg;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1_b_reg <= 1'b0;
            en_sync2_b_reg <= 1'b0;
        end else begin
            en_sync1_b_reg <= en_reg_a;
            en_sync2_b_reg <= en_sync1_b;
        end
    end

    // Data output register
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync2_b) begin
            dataout <= data_reg_a;
        end
    end

endmodule