module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    typedef enum logic [1:0] {
        IDLE,
        CAPTURE,
        COUNT,
        DONE
    } state_t;

    state_t state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [2:0] bit_cnt;
    reg [13:0] counter;  // Counts up to (15+1)*1000 = 16000 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            bit_cnt <= 3'b0;
            counter <= 14'b0;
            count <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data};

            case (state)
                IDLE: begin
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_cnt <= 3'b0;
                    end
                end

                CAPTURE: begin
                    if (bit_cnt == 3'b100) begin
                        state <= COUNT;
                        counter <= 14'b0;
                    end else begin
                        delay <= {delay[2:0], data};
                        bit_cnt <= bit_cnt + 1;
                    end
                end

                COUNT: begin
                    if (counter == {delay, 10'b0} + 14'd1000 - 1) begin
                        state <= DONE;
                    end else begin
                        counter <= counter + 1;
                        count <= delay - counter[13:10];  // Automatically decrements every 1000 cycles
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule