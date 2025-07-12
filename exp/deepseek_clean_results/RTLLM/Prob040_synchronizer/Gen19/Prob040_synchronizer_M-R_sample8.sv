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
    reg [3:0] data_reg;
    reg en_reg;
    
    // Clock domain B registers
    reg en_sync1, en_sync2;
    reg [3:0] dataout_reg;
    
    // Clock domain A logic (combinational next-state)
    wire [3:0] next_data_reg = !arstn ? 4'b0 : data_in;
    wire next_en_reg = !arstn ? 1'b0 : data_en;
    
    // Clock domain B logic (combinational next-state)
    wire next_en_sync1 = !brstn ? 1'b0 : en_reg;
    wire next_en_sync2 = !brstn ? 1'b0 : en_sync1;
    wire [3:0] next_dataout_reg = !brstn ? 4'b0 : 
                                 (en_sync2 ? data_reg : dataout_reg);
    
    // Register updates
    always @(posedge clk_a) begin
        data_reg <= next_data_reg;
        en_reg <= next_en_reg;
    end
    
    always @(posedge clk_b) begin
        en_sync1 <= next_en_sync1;
        en_sync2 <= next_en_sync2;
        dataout_reg <= next_dataout_reg;
    end
    
    // Continuous output assignment
    assign dataout = dataout_reg;

endmodule