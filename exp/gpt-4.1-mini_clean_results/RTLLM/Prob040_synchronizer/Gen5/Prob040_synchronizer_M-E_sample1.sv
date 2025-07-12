module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // FIFO registers in clk_a domain: 1-depth FIFO for data and valid
    reg [3:0] fifo_data;
    reg       fifo_valid;

    // On clk_a: sample data_in into fifo_data when data_en is asserted and fifo is free
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            fifo_data  <= 4'd0;
            fifo_valid <= 1'b0;
        end else begin
            // Load new data only if fifo is empty and data_en is high
            if (data_en && !fifo_valid) begin
                fifo_data  <= data_in;
                fifo_valid <= 1'b1;
            end
            // Otherwise keep previous fifo_data and fifo_valid
        end
    end

    // Synchronize fifo_valid (clk_a domain) into clk_b domain using 2-stage synchronizer
    reg fifo_valid_sync_1, fifo_valid_sync_2;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            fifo_valid_sync_1 <= 1'b0;
            fifo_valid_sync_2 <= 1'b0;
        end else begin
            fifo_valid_sync_1 <= fifo_valid;
            fifo_valid_sync_2 <= fifo_valid_sync_1;
        end
    end

    // Latch fifo_data into dataout in clk_b domain when fifo_valid_sync_2 goes high (data ready)
    // Keep track of last fifo_valid_sync_2 to detect rising edge
    reg fifo_valid_sync_2_d;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout          <= 4'd0;
            fifo_valid_sync_2_d <= 1'b0;
        end else begin
            fifo_valid_sync_2_d <= fifo_valid_sync_2;

            // On rising edge of fifo_valid_sync_2, latch fifo_data into dataout
            if (fifo_valid_sync_2 && !fifo_valid_sync_2_d) begin
                dataout <= fifo_data;
            end
            // else retain previous dataout
        end
    end

    // Generate an acknowledge signal from clk_b domain to clear fifo_valid in clk_a domain
    // Synchronize fifo_valid_sync_2_d back to clk_a domain for handshake completion
    reg ack_to_a_1, ack_to_a_2;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            ack_to_a_1 <= 1'b0;
            ack_to_a_2 <= 1'b0;
        end else begin
            ack_to_a_1 <= fifo_valid_sync_2_d;
            ack_to_a_2 <= ack_to_a_1;
        end
    end

    // Clear fifo_valid in clk_a domain once ack received (handshake complete)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            fifo_valid <= 1'b0;
        end else begin
            // fifo_valid stays set until ack_to_a_2 is asserted (data received)
            if (fifo_valid && ack_to_a_2)
                fifo_valid <= 1'b0;
            // else fifo_valid holds
        end
    end

endmodule