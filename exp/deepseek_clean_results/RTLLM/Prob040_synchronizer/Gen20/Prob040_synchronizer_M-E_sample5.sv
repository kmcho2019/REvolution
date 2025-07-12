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
    reg [1:0] req_a;  // Metastability filter for request
    reg req_sent;
    reg [3:0] data_hold;
    reg [2:0] stability_counter;

    // Clock domain B signals
    reg [1:0] ack_b;  // Metastability filter for acknowledge
    reg ack_received;
    reg [3:0] data_sync;
    reg [1:0] watchdog;

    // Gray-coded state machine
    localparam IDLE = 2'b00;
    localparam REQ_SENT = 2'b01;
    localparam ACK_RECEIVED = 2'b11;
    localparam COMPLETE = 2'b10;
    reg [1:0] state_a, next_state_a;

    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            req_a <= 2'b0;
            req_sent <= 1'b0;
            data_hold <= 4'b0;
            stability_counter <= 3'b0;
            state_a <= IDLE;
        end else begin
            // Metastability filter for ack
            req_a <= {req_a[0], ack_received};

            // Data stability counter
            if (data_en && !req_sent) begin
                if (data_hold == data_in)
                    stability_counter <= stability_counter + 1;
                else begin
                    data_hold <= data_in;
                    stability_counter <= 3'b0;
                end
            end

            // State machine
            state_a <= next_state_a;

            case (state_a)
                IDLE: begin
                    if (data_en && stability_counter >= 3'd3) begin
                        req_sent <= 1'b1;
                        data_hold <= data_in;
                    end
                end
                REQ_SENT: begin
                    if (req_a[1]) begin
                        req_sent <= 1'b0;
                    end
                end
                COMPLETE: begin
                    stability_counter <= 3'b0;
                end
            endcase
        end
    end

    // Clock domain A next state logic
    always @(*) begin
        next_state_a = state_a;
        case (state_a)
            IDLE: if (data_en && stability_counter >= 3'd3) next_state_a = REQ_SENT;
            REQ_SENT: if (req_a[1]) next_state_a = ACK_RECEIVED;
            ACK_RECEIVED: next_state_a = COMPLETE;
            COMPLETE: next_state_a = IDLE;
        endcase
    end

    // Clock domain B logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            ack_b <= 2'b0;
            ack_received <= 1'b0;
            dataout <= 4'b0;
            data_sync <= 4'b0;
            watchdog <= 2'b0;
        end else begin
            // Metastability filter for request
            ack_b <= {ack_b[0], req_sent};

            // Watchdog timer
            if (ack_b[1] && !ack_received)
                watchdog <= watchdog + 1;
            else
                watchdog <= 2'b0;

            // Data capture and acknowledge
            if (ack_b[1] && !ack_received) begin
                data_sync <= data_hold;
                ack_received <= 1'b1;
            end else if (!ack_b[1] && ack_received) begin
                ack_received <= 1'b0;
            end

            // Output update
            if (ack_received) begin
                dataout <= data_sync;
            end

            // Watchdog recovery
            if (watchdog == 2'b11) begin
                ack_received <= 1'b0;
                dataout <= dataout;  // Hold previous value
            end
        end
    end

endmodule