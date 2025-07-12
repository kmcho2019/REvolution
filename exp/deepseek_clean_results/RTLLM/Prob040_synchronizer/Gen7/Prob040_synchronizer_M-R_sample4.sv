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
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
        end else if (data_en) begin
            data_reg <= data_in;
            en_reg <= 1'b1;
        end else begin
            en_reg <= 1'b0;
        end
    end

    // Clock domain B synchronizer
    reg en_sync1, en_sync2;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_reg;
            en_sync2 <= en_sync1;
        end
    end

    // Output mux logic
    wire [3:0] next_dataout = en_sync2 ? data_reg : dataout;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= next_dataout;
        end
    end

endmodule