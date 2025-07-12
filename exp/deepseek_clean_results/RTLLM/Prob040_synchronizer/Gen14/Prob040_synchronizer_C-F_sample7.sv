module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain - Request generation
    reg [3:0] data_reg;
    reg req_a;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else if (data_en) begin
            data_reg <= data_in;
            req_a <= 1'b1;
        end else begin
            req_a <= 1'b0;
        end
    end

    // Clock B domain - Request synchronization
    reg req_sync1, req_sync2;
    reg ack_b;
    wire clk_b_gated = clk_b & ((req_sync2 & ~ack_b) | ~brstn);
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync1 <= 1'b0;
            req_sync2 <= 1'b0;
            ack_b <= 1'b0;
        end else begin
            req_sync1 <= req_a;
            req_sync2 <= req_sync1;
            ack_b <= req_sync2;
        end
    end

    // Clock A domain - Acknowledge synchronization
    reg ack_sync1;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_sync1 <= 1'b0;
        end else begin
            ack_sync1 <= ack_b;
        end
    end

    // Clock B domain - Output register with conditional update
    always @(posedge clk_b_gated or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= data_reg;
        end
    end

endmodule