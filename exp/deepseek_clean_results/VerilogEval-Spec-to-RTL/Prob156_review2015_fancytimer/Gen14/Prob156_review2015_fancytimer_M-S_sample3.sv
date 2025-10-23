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
    localparam CAPTURE = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [15:0] timer;
    reg [2:0] bit_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_cnt <= 0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                CAPTURE: begin
                    if (bit_cnt < 4) begin
                        delay <= {delay[2:0], data};
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        state <= COUNT;
                        timer <= (delay + 1) * 1000 - 1;
                        counting <= 1;
                    end
                end

                COUNT: begin
                    if (timer == 0) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        timer <= timer - 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase

            // Update count output
            count <= (state == COUNT) ? (timer / 1000) : 4'b0;
        end
    end

endmodule