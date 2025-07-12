module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output wire [3:0] dataout
);

    // Two-stage synchronizer registers
    reg en_sync1, en_sync2;
    
    // Synchronizer logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= data_en;
            en_sync2 <= en_sync1;
        end
    end

    // Output data register
    reg [3:0] dataout_reg;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout_reg <= 4'b0;
        end
    end

    // Output data selection using continuous assignment
    assign dataout = en_sync2 ? data_in : dataout_reg;

    // Update the output register when enabled
    always @(posedge clk_b) begin
        if (en_sync2) begin
            dataout_reg <= data_in;
        end
    end

endmodule