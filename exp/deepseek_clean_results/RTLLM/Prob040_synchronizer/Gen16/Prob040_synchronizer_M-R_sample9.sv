module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain registers
    reg [3:0] data_reg;
    reg req_a;
    
    // Clock B domain registers
    reg req_sync1, req_sync2;
    reg data_valid;
    
    // Clock A domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else begin
            data_reg <= data_en ? data_in : data_reg;
            req_a <= data_en;
        end
    end

    // Clock B domain synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync1 <= 1'b0;
            req_sync2 <= 1'b0;
            data_valid <= 1'b0;
        end else begin
            req_sync1 <= req_a;
            req_sync2 <= req_sync1;
            data_valid <= req_sync2;
        end
    end

    // Output register with clock enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (data_valid) begin
            dataout <= data_reg;
        end
    end

endmodule