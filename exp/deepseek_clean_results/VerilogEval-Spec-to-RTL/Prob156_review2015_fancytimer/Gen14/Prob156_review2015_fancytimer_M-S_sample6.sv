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
        COUNT,
        DONE
    } state_t;

    state_t state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [2:0] bit_cnt;
    reg [13:0] counter;

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
                        if (bit_cnt == 3'b100) begin
                            state <= COUNT;
                            counter <= 14'b0;
                            count <= delay;
                        end else begin
                            delay <= {delay[2:0], data};
                            bit_cnt <= bit_cnt + 1;
                        end
                    end else begin
                        bit_cnt <= 3'b0;
                    end
                end

                COUNT: begin
                    if (counter[9:0] == 10'd999) begin
                        if (count == 4'b0) begin
                            state <= DONE;
                        end else begin
                            count <= count - 1;
                        end
                    end
                    counter <= counter + 1;
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