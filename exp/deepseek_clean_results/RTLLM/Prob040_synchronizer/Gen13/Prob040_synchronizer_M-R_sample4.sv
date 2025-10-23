module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output wire [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg_a;
    reg en_reg_a;
    
    // Clock domain B synchronization registers
    reg en_sync1, en_sync2;
    reg [3:0] data_reg_b;
    
    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a <= 1'b0;
        end else begin
            data_reg_a <= data_in;
            en_reg_a <= data_en;
        end
    end
    
    // Clock domain B synchronization logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_reg_a;
            en_sync2 <= en_sync1;
        end
    end
    
    // Clock domain B data capture logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_b <= 4'b0;
        end else if (en_sync1) begin
            data_reg_b <= data_reg_a;
        end
    end
    
    // Output assignment
    assign dataout = en_sync2 ? data_reg_b : 4'b0;

endmodule