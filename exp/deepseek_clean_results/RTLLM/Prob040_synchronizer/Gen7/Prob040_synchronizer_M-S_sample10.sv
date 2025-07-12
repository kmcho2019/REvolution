module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Combined data and enable capture in clk_a domain
    reg [4:0] a_domain;  // {data_en, data_in}
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            a_domain <= 5'b0;
        end else begin
            a_domain <= {data_en, data_in};
        end
    end

    // Two-stage synchronizer in clk_b domain
    reg [4:0] b_sync1, b_sync2;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            b_sync1 <= 5'b0;
            b_sync2 <= 5'b0;
        end else begin
            b_sync1 <= a_domain;
            b_sync2 <= b_sync1;
        end
    end

    // Output assignment
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= b_sync2[3:0];  // Data is valid when enable propagates
        end
    end

endmodule