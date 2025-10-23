module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State definitions
    localparam IDLE    = 2'b00;
    localparam PATTERN = 2'b01;
    localparam CAPTURE = 2'b10;
    localparam COUNT   = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [1:0] bits_captured;
    reg [15:0] counter;  // Handles up to 16*1000 = 16000 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            bits_captured <= 2'b0;
            counter <= 16'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    state <= PATTERN;
                end

                PATTERN: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bits_captured <= 2'b0;
                    end
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    bits_captured <= bits_captured + 1;
                    if (bits_captured == 3) begin
                        state <= COUNT;
                        counting <= 1'b1;
                        counter <= (delay + 1) * 1000;
                        count <= delay;
                    end
                end

                COUNT: begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                        // Update count output every 1000 cycles
                        if (counter % 1000 == 0)
                            count <= (counter / 1000) - 1;
                    end else begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        if (ack) begin
                            state <= IDLE;
                            done <= 1'b0;
                        end
                    end
                end
            endcase
        end
    end

endmodule