module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain signals
    reg [3:0] data_reg;
    reg req_a;
    wire ack_sync;

    // clk_b domain signals
    reg [3:0] data_buf;
    reg ack_b;
    wire req_sync;

    // Synchronizers
    reg req_sync1, req_sync2;
    reg ack_sync1, ack_sync2;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else begin
            if (data_en && !req_a && !ack_sync) begin
                data_reg <= data_in;
                req_a <= 1'b1;
            end else if (req_a && ack_sync) begin
                req_a <= 1'b0;
            end
        end
    end

    // req_a to clk_b synchronizer
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            {req_sync1, req_sync2} <= 2'b00;
        end else begin
            req_sync1 <= req_a;
            req_sync2 <= req_sync1;
        end
    end

    // clk_b domain logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_buf <= 4'b0;
            dataout <= 4'b0;
            ack_b <= 1'b0;
        end else begin
            // Capture data when new request arrives
            if (req_sync2 && !ack_b) begin
                data_buf <= data_reg;
                ack_b <= 1'b1;
            end else if (!req_sync2 && ack_b) begin
                ack_b <= 1'b0;
            end

            // Update output whenever we have new data
            if (ack_b) begin
                dataout <= data_buf;
            end
        end
    end

    // ack_b to clk_a synchronizer
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            {ack_sync1, ack_sync2} <= 2'b00;
        end else begin
            ack_sync1 <= ack_b;
            ack_sync2 <= ack_sync1;
        end
    end

    assign req_sync = req_sync2;
    assign ack_sync = ack_sync2;

endmodule