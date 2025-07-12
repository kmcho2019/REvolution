module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam COUNT   = 2'b10;
    localparam WAIT_ACK = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [2:0] bit_cnt;
    reg [9:0] fine_cnt;  // Counts 0-999
    reg [3:0] coarse_cnt; // Counts delay down to 0

    // Pattern detection
    wire pattern_match = (shift_reg == 4'b1101);

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            bit_cnt <= 3'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (pattern_match) begin
                        bit_cnt <= 3'b0;
                    end
                end

                RECEIVE: begin
                    if (bit_cnt < 4) begin
                        delay <= {delay[2:0], data};
                        bit_cnt <= bit_cnt + 1;
                    end
                end

                COUNT: begin
                    if (fine_cnt == 10'd999) begin
                        fine_cnt <= 10'd0;
                        coarse_cnt <= coarse_cnt - 1;
                    end else begin
                        fine_cnt <= fine_cnt + 1;
                    end
                end

                WAIT_ACK: begin
                    if (ack) begin
                        shift_reg <= 4'b0;
                        done <= 1'b0;
                    end
                end
            endcase

            // Output registers
            counting <= (state == COUNT);
            done <= (state == WAIT_ACK);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = pattern_match ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_cnt == 4) ? COUNT : RECEIVE;
            COUNT: begin
                if (fine_cnt == 10'd999 && coarse_cnt == 4'd0)
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end
            WAIT_ACK: next_state = ack ? IDLE : WAIT_ACK;
            default: next_state = IDLE;
        endcase
    end

    // Count output calculation
    always @(*) begin
        if (state == COUNT) begin
            if (fine_cnt == 10'd999)
                count = coarse_cnt - 1;
            else
                count = coarse_cnt;
        end else begin
            count = 4'b0;
        end
    end

    // Initialize counters when entering COUNT state
    always @(posedge clk) begin
        if (state == RECEIVE && next_state == COUNT) begin
            coarse_cnt <= delay;
            fine_cnt <= 10'd0;
        end
    end

endmodule