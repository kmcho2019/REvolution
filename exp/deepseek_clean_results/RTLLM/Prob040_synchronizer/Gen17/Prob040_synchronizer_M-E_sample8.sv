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

    // Handshake signals
    reg req_a, ack_b;
    reg req_b_meta, req_b_sync;
    
    // Data capture register
    reg [3:0] captured_data;
    
    // Gray code conversion for enable signal
    wire req_a_gray = req_a ^ ack_b;
    
    // clk_a domain: request generation
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            req_a <= 1'b0;
        end else if (data_en) begin
            req_a <= ~req_a; // Toggle request
        end
    end
    
    // clk_b domain: request synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_b_meta <= 1'b0;
            req_b_sync <= 1'b0;
            ack_b <= 1'b0;
        end else begin
            req_b_meta <= req_a_gray;
            req_b_sync <= req_b_meta;
            // Generate acknowledge when request is stable
            if (req_b_sync != ack_b) begin
                ack_b <= req_b_sync;
            end
        end
    end
    
    // Data stability checker and capture
    reg [3:0] prev_data;
    reg [1:0] stable_count;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            prev_data <= 4'b0;
            stable_count <= 2'b0;
            captured_data <= 4'b0;
            data_valid <= 1'b0;
        end else begin
            // Check for data stability
            if (data_in == prev_data) begin
                stable_count <= stable_count + 1;
            end else begin
                stable_count <= 2'b0;
                prev_data <= data_in;
            end
            
            // Capture data when stable and handshake complete
            if (stable_count >= 2'b10 && req_b_sync != ack_b) begin
                captured_data <= data_in;
                dataout <= data_in;
                data_valid <= 1'b1;
            end else if (req_b_sync == ack_b) begin
                data_valid <= 1'b0;
            end
        end
    end

endmodule