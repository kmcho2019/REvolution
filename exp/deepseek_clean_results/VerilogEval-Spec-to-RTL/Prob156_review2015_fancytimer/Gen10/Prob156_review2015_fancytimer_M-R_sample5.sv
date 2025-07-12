module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam CAPTURE = 4'b0010;
    localparam COUNT   = 4'b0100;
    localparam DONE    = 4'b1000;

    reg [3:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay_val;
    reg [1:0] bit_cnt;
    reg [9:0] cycle_cnt;
    reg [3:0] delay_cnt;

    // Shift register for pattern detection
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (state == IDLE) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay_val <= 4'b0;
            bit_cnt <= 2'b0;
            cycle_cnt <= 10'b0;
            delay_cnt <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_cnt <= 2'b0;
                    end
                end

                CAPTURE: begin
                    if (bit_cnt == 2'b11) begin
                        state <= COUNT;
                        delay_cnt <= {delay_val[2:0], data};
                        cycle_cnt <= 10'b0;
                    end else begin
                        delay_val <= {delay_val[2:0], data};
                        bit_cnt <= bit_cnt + 1;
                    end
                end

                COUNT: begin
                    if (cycle_cnt == 10'd999) begin
                        if (delay_cnt == 4'b0) begin
                            state <= DONE;
                        end else begin
                            delay_cnt <= delay_cnt - 1;
                            cycle_cnt <= 10'b0;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
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

    // Output assignments
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    assign count = (state == COUNT) ? delay_cnt : 4'b0;

endmodule