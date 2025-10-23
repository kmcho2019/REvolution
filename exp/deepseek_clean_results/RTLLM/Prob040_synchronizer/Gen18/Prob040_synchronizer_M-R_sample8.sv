module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data path registers
    reg [3:0] data_reg;
    wire [3:0] next_data_reg;
    
    // Enable synchronization path
    reg en_sync1, en_sync2;
    wire next_en_sync1, next_en_sync2;
    
    // Next state logic for data register (clock domain A)
    assign next_data_reg = (!arstn) ? 4'b0 : 
                         (data_en) ? data_in : data_reg;
    
    // Next state logic for enable sync (clock domain B)
    assign next_en_sync1 = (!brstn) ? 1'b0 : data_en;
    assign next_en_sync2 = (!brstn) ? 1'b0 : en_sync1;
    
    // Data register update (clock domain A)
    always @(posedge clk_a) begin
        data_reg <= next_data_reg;
    end
    
    // Enable synchronization update (clock domain B)
    always @(posedge clk_b) begin
        en_sync1 <= next_en_sync1;
        en_sync2 <= next_en_sync2;
    end
    
    // Output assignment (clock domain B)
    always @(posedge clk_b) begin
        dataout <= (!brstn) ? 4'b0 : 
                  (en_sync2) ? data_reg : dataout;
    end

endmodule