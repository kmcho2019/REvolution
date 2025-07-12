module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A signals
    reg [3:0] data_reg_a;
    reg req_a;
    wire ack_b_sync;

    // Clock domain B signals
    reg [3:0] data_reg_b;
    reg ack_b;
    reg req_a_sync1, req_a_sync2;
    reg ack_b_sync1, ack_b_sync2;

    // State encoding for handshake
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;
    reg state_a, state_b;

    // Continuous assignments
    assign ack_b_sync = ack_b_sync2;

    // Clock domain A logic - request generation
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            req_a <= 1'b0;
            state_a <= IDLE;
        end else begin
            case (state_a)
                IDLE: begin
                    if (data_en) begin
                        data_reg_a <= data_in;
                        req_a <= 1'b1;
                        state_a <= BUSY;
                    end
                end
                BUSY: begin
                    if (ack_b_sync) begin
                        req_a <= 1'b0;
                        state_a <= IDLE;
                    end
                end
            endcase
        end
    end

    // Clock domain B logic - request synchronization and data capture
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_a_sync1 <= 1'b0;
            req_a_sync2 <= 1'b0;
            ack_b <= 1'b0;
            data_reg_b <= 4'b0;
            dataout <= 4'b0;
            state_b <= IDLE;
            ack_b_sync1 <= 1'b0;
            ack_b_sync2 <= 1'b0;
        end else begin
            // Synchronize request from domain A
            req_a_sync1 <= req_a;
            req_a_sync2 <= req_a_sync1;

            // Synchronize acknowledge to domain A
            ack_b_sync1 <= ack_b;
            ack_b_sync2 <= ack_b_sync1;

            case (state_b)
                IDLE: begin
                    if (req_a_sync2) begin
                        data_reg_b <= data_reg_a;
                        ack_b <= 1'b1;
                        state_b <= BUSY;
                    end
                end
                BUSY: begin
                    if (!req_a_sync2) begin
                        ack_b <= 1'b0;
                        state_b <= IDLE;
                    end
                    dataout <= data_reg_b;
                end
            endcase
        end
    end

endmodule