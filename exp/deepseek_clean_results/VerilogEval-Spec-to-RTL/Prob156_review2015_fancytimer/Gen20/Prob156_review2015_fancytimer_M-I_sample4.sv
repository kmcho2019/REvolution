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
    localparam IDLE     = 3'b000;
    localparam PATTERN  = 3'b001;
    localparam CAPTURE  = 3'b010;
    localparam COUNTING = 3'b011;
    localparam DONE     = 3'b100;

    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [1:0] bit_count;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] delay_counter;  // Counts delay down to 0

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            bit_count <= 2'b0;
            cycle_counter <= 10'b0;
            delay_counter <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    state <= PATTERN;
                end

                PATTERN: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_count <= 2'b0;
                    end
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        delay_counter <= delay;
                        count <= delay;
                        cycle_counter <= 10'b0;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 10'b0;
                        if (delay_counter == 0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                            count <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule