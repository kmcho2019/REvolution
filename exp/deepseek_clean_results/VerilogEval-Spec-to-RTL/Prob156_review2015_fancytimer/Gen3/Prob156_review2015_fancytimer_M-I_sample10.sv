module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE = 0;
    localparam DETECT_PATTERN = 1;
    localparam CAPTURE_DELAY = 2;
    localparam COUNTING = 3;
    localparam FINISHED = 4;

    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [1:0] bit_counter;
    reg [3:0] delay;
    reg [9:0] prescaler;
    reg [3:0] delay_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            bit_counter <= 2'b0;
            delay <= 4'b0;
            prescaler <= 10'b0;
            delay_counter <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 2'b0;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                CAPTURE_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (bit_counter == 2'd3) begin
                        delay <= shift_reg;
                        state <= COUNTING;
                        delay_counter <= shift_reg;
                        prescaler <= 10'b0;
                        counting <= 1'b1;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end

                COUNTING: begin
                    if (prescaler == 10'd999) begin
                        prescaler <= 10'b0;
                        if (delay_counter == 4'b0) begin
                            state <= FINISHED;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        prescaler <= prescaler + 1;
                    end
                    count <= delay_counter;
                end

                FINISHED: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule