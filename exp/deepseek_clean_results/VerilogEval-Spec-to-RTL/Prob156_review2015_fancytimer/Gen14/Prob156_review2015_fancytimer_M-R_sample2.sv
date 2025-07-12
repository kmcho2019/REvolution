module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    typedef enum logic [1:0] {
        IDLE,
        CAPTURE_DELAY,
        COUNTING,
        DONE
    } state_t;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [3:0] remaining;
    reg [9:0] sub_counter;  // Counts 0-999
    reg [3:0] bit_counter;

    // Pattern detection and state control
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            bit_counter <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data};

            case (state)
                IDLE: begin
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 4'b0;
                    end
                end

                CAPTURE_DELAY: begin
                    if (bit_counter == 4'd3) begin
                        state <= COUNTING;
                        remaining <= {delay[2:0], data};
                        sub_counter <= 10'b0;
                    end else begin
                        delay <= {delay[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end

                COUNTING: begin
                    if (sub_counter == 10'd999) begin
                        sub_counter <= 10'b0;
                        if (remaining == 4'b0)
                            state <= DONE;
                        else
                            remaining <= remaining - 1;
                    end else begin
                        sub_counter <= sub_counter + 1;
                    end
                end

                DONE: begin
                    if (ack)
                        state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign count = (state == COUNTING) ? remaining : 4'b0;
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

endmodule