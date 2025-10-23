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
    reg [3:0] data_hold;
    
    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_reg <= data_en;
        end
    end
    
    // Clock domain B synchronization logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_reg;
            en_sync2 <= en_sync1;
        end
    end
    
    // Clock domain B data path
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_hold <= 4'b0;
        end else begin
            if (en_sync2) begin
                data_hold <= data_reg;
            end
        end
    end
    
    // Output assignment
    assign dataout = en_sync2 ? data_reg : data_hold;

endmodule