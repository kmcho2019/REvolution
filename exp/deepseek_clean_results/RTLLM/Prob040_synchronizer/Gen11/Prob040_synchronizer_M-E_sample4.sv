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
    reg [3:0] data_buf [0:1];
    reg buf_wptr;  // Gray coded write pointer
    reg req_sync;

    // Clock domain B registers
    reg [3:0] data_buf_b [0:1];
    reg buf_rptr;  // Gray coded read pointer
    reg ack_sync1, ack_sync2;
    reg req_sync1, req_sync2;

    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_buf[0] <= 4'b0;
            data_buf[1] <= 4'b0;
            buf_wptr <= 1'b0;
            req_sync <= 1'b0;
        end else if (data_en) begin
            // Store data in buffer and toggle write pointer
            data_buf[buf_wptr] <= data_in;
            buf_wptr <= ~buf_wptr;
            req_sync <= ~req_sync;  // Toggle request
        end
    end

    // Clock domain B logic - synchronizers
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync1 <= 1'b0;
            req_sync2 <= 1'b0;
            ack_sync1 <= 1'b0;
            ack_sync2 <= 1'b0;
        end else begin
            // Synchronize request from domain A
            req_sync1 <= req_sync;
            req_sync2 <= req_sync1;
            
            // Synchronize acknowledge back to domain A
            ack_sync1 <= ack_sync2;
            ack_sync2 <= buf_rptr;
        end
    end

    // Clock domain B logic - data handling
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_buf_b[0] <= 4'b0;
            data_buf_b[1] <= 4'b0;
            buf_rptr <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Detect request change (using XOR)
            if (req_sync1 ^ req_sync2) begin
                // Capture data from opposite buffer
                data_buf_b[~buf_rptr] <= data_buf[~buf_rptr];
                // Toggle read pointer
                buf_rptr <= ~buf_rptr;
            end
            
            // Output the current data
            dataout <= data_buf_b[buf_rptr];
        end
    end

endmodule