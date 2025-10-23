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
    wire ack_sync_a;

    // Clock domain B signals
    reg [3:0] data_reg_b;
    reg ack_b;
    reg [1:0] sync_req_a;
    reg [1:0] sync_ack_b;

    // Domain A state machine
    localparam IDLE_A = 1'b0, REQ_A = 1'b1;
    reg state_a;

    // Domain B state machine
    localparam IDLE_B = 1'b0, ACK_B = 1'b1;
    reg state_b;

    // Domain A combinational logic
    assign ack_sync_a = sync_ack_b[1];

    // Domain A sequential logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            req_a <= 1'b0;
            state_a <= IDLE_A;
        end else begin
            case (state_a)
                IDLE_A: begin
                    if (data_en) begin
                        data_reg_a <= data_in;
                        req_a <= 1'b1;
                        state_a <= REQ_A;
                    end
                end
                REQ_A: begin
                    if (ack_sync_a) begin
                        req_a <= 1'b0;
                        state_a <= IDLE_A;
                    end
                end
            endcase
        end
    end

    // Domain B request synchronizer
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_req_a <= 2'b0;
        end else begin
            sync_req_a <= {sync_req_a[0], req_a};
        end
    end

    // Domain B state machine
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_b <= 4'b0;
            dataout <= 4'b0;
            ack_b <= 1'b0;
            state_b <= IDLE_B;
            sync_ack_b <= 2'b0;
        end else begin
            // Default assignments
            sync_ack_b <= {sync_ack_b[0], ack_b};

            case (state_b)
                IDLE_B: begin
                    if (sync_req_a[1]) begin
                        data_reg_b <= data_reg_a;
                        ack_b <= 1'b1;
                        state_b <= ACK_B;
                    end
                end
                ACK_B: begin
                    if (!sync_req_a[1]) begin
                        ack_b <= 1'b0;
                        state_b <= IDLE_B;
                    end
                end
            endcase

            // Output register
            if (ack_b) begin
                dataout <= data_reg_b;
            end
        end
    end

endmodule