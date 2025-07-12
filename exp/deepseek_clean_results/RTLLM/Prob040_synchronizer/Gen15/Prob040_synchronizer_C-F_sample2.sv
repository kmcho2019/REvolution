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
    wire clk_a_gated;

    // clk_b domain signals
    reg ack_b;
    wire req_sync;

    // Synchronizers
    reg req_sync1, req_sync2;
    reg ack_sync1, ack_sync2;

    // Clock gating for data_reg
    assign clk_a_gated = clk_a & (data_en | ~arstn);

    // clk_a domain logic with gated clock
    always @(posedge clk_a_gated or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else begin
            data_reg <= data_in;
        end
    end

    // Request generation (ungated clock)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            req_a <= 1'b0;
        end else begin
            if (data_en && !req_a && !ack_sync) begin
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
            dataout <= 4'b0;
            ack_b <= 1'b0;
        end else begin
            // Capture data when new request arrives
            if (req_sync2 && !ack_b) begin
                dataout <= data_reg;
                ack_b <= 1'b1;
            end else if (!req_sync2 && ack_b) begin
                ack_b <= 1'b0;
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