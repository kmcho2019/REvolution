module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State encoding
    localparam IDLE    = 3'b000;
    localparam WAIT    = 3'b001;
    localparam CAPTURE = 3'b010;
    localparam COUNT   = 3'b011;
    localparam DONE    = 3'b100;

    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay_val;
    reg [1:0] bit_cnt;
    reg [13:0] main_counter;
    reg [9:0] sub_counter;
    reg [3:0] periods_remaining;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_cnt <= 2'b0;
            main_counter <= 14'b0;
            sub_counter <= 10'b0;
            periods_remaining <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= WAIT;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                WAIT: begin
                    state <= CAPTURE;
                    bit_cnt <= 2'b0;
                end

                CAPTURE: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 2'b11) begin
                        state <= COUNT;
                        periods_remaining <= delay_val;
                        main_counter <= 14'b0;
                        sub_counter <= 10'b0;
                        counting <= 1'b1;
                    end
                end

                COUNT: begin
                    if (sub_counter == 10'd999) begin
                        sub_counter <= 10'b0;
                        if (periods_remaining == 4'b0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            periods_remaining <= periods_remaining - 1;
                        end
                    end else begin
                        sub_counter <= sub_counter + 1;
                    end
                    main_counter <= main_counter + 1;
                    count <= periods_remaining;
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule