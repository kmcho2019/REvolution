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
    reg req_toggle;
    reg data_en_ff;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_toggle <= 1'b0;
            data_en_ff <= 1'b0;
        end else begin
            data_en_ff <= data_en;
            // Only update when data_en changes to high
            if (data_en && !data_en_ff) begin
                data_reg <= data_in;
                req_toggle <= ~req_toggle; // Toggle request
            end
        end
    end

    // Clock domain B synchronization
    reg [1:0] sync_req;
    reg [3:0] data_hold;
    reg ack_b;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_req <= 2'b00;
            dataout <= 4'b0;
            data_hold <= 4'b0;
            ack_b <= 1'b0;
        end else begin
            // 2-stage synchronizer
            sync_req <= {sync_req[0], req_toggle};
            
            // Detect toggle (edge)
            if (sync_req[1] ^ sync_req[0]) begin
                data_hold <= data_reg;
                ack_b <= 1'b1;
            end else begin
                ack_b <= 1'b0;
            end
            
            // Output assignment
            if (ack_b) begin
                dataout <= data_hold;
            end
        end
    end

endmodule