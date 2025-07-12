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
    wire data_reg_en;

    // clk_b domain signals
    reg [3:0] data_buf;
    reg ack_b;
    wire req_sync;
    wire data_buf_en;

    // Synchronizers
    reg req_sync1, req_sync2;
    reg ack_sync1, ack_sync2;

    // Clock gating enables
    assign data_reg_en = data_en && !req_a && !ack_sync;
    assign data_buf_en = req_sync2 && !ack_b;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else begin
            if (data_reg_en) begin
                data_reg <= data_in;
                req_a <= 1'b1;
            end else if (ack_sync) begin
                req_a <= 1'b0;
            end
        end
    end

    // req_a to clk_b synchronizer (2-stage for metastability)
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
            // Single-stage data capture with enable
            if (data_buf_en) begin
                data_buf <= data_reg;
                ack_b <= 1'b1;
            end else if (!req_sync2) begin
                ack_b <= 1'b0;
            end

            // Output update
            dataout <= data_buf;
        end
    end

    // ack_b to clk_a synchronizer (2-stage for metastability)
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