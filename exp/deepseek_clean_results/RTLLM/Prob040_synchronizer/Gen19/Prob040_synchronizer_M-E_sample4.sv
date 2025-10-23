module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout,
    output reg data_valid
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg req_a;
    reg [1:0] gray_req; // Gray coded request

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
            gray_req <= 2'b00;
        end else begin
            if (data_en) begin
                data_reg <= data_in;
                req_a <= 1'b1;
                // Convert binary request to gray code
                gray_req <= {req_a, ~req_a};
            end else begin
                req_a <= 1'b0;
                gray_req <= 2'b00;
            end
        end
    end

    // Clock domain B synchronization
    reg [1:0] sync_gray;
    reg [1:0] sync_gray_ff;
    reg ack_b;
    reg [3:0] data_hold;

    // Gray code synchronizer (2-stage)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_gray <= 2'b00;
            sync_gray_ff <= 2'b00;
            ack_b <= 1'b0;
            dataout <= 4'b0;
            data_valid <= 1'b0;
            data_hold <= 4'b0;
        end else begin
            // Sync gray request
            sync_gray <= gray_req;
            sync_gray_ff <= sync_gray;
            
            // Gray to binary conversion
            if (sync_gray_ff == 2'b01 || sync_gray_ff == 2'b10) begin
                ack_b <= 1'b1;
                data_hold <= data_reg;
            end else begin
                ack_b <= 1'b0;
            end
            
            // Output with valid signal
            dataout <= data_hold;
            data_valid <= ack_b;
        end
    end

endmodule