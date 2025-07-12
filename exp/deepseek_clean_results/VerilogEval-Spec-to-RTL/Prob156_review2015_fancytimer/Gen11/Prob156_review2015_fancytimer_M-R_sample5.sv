module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam [1:0] IDLE    = 2'b00;
    localparam [1:0] CAPTURE = 2'b01;
    localparam [1:0] COUNT   = 2'b10;
    localparam [1:0] DONE    = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [1:0] bit_cnt;
    reg [13:0] cycle_counter;
    wire pattern_match = (shift_reg == 4'b1101);

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (state == IDLE) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay <= 4'b0;
            bit_cnt <= 2'b0;
            cycle_counter <= 14'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_match) begin
                        state <= CAPTURE;
                        bit_cnt <= 2'b0;
                    end
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    if (bit_cnt == 2'b11) begin
                        state <= COUNT;
                        cycle_counter <= (delay + 1) * 14'd1000 - 1;
                    end
                    bit_cnt <= bit_cnt + 1;
                end

                COUNT: begin
                    if (cycle_counter == 14'b0) begin
                        state <= DONE;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                    end
                    // Update count output every 1000 cycles
                    count <= cycle_counter / 14'd1000;
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule