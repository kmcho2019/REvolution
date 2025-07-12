module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain
    reg [3:0] a_data;
    reg a_req;
    wire a_ack;

    // clk_b domain
    reg [3:0] b_data;
    reg b_ack;
    wire b_req;

    // State machine states
    localparam IDLE = 1'b0;
    localparam TRANSFER = 1'b1;
    reg state_a, state_b;

    // Synchronizers
    reg [1:0] sync_req;
    reg [1:0] sync_ack;

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            a_data <= 4'b0;
            state_a <= IDLE;
        end else begin
            case (state_a)
                IDLE: if (data_en) begin
                    a_data <= data_in;
                    state_a <= TRANSFER;
                end
                TRANSFER: if (a_ack) state_a <= IDLE;
            endcase
        end
    end

    assign a_req = (state_a == TRANSFER);

    // req synchronization to clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_req <= 2'b00;
        end else begin
            sync_req <= {sync_req[0], a_req};
        end
    end

    assign b_req = sync_req[1];

    // clk_b domain logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            b_data <= 4'b0;
            dataout <= 4'b0;
            state_b <= IDLE;
        end else begin
            case (state_b)
                IDLE: if (b_req) begin
                    b_data <= a_data;
                    state_b <= TRANSFER;
                end
                TRANSFER: if (!b_req) state_b <= IDLE;
            endcase
            
            // Output update
            if (state_b == TRANSFER)
                dataout <= b_data;
        end
    end

    assign b_ack = (state_b == TRANSFER);

    // ack synchronization to clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            sync_ack <= 2'b00;
        end else begin
            sync_ack <= {sync_ack[0], b_ack};
        end
    end

    assign a_ack = sync_ack[1];

endmodule