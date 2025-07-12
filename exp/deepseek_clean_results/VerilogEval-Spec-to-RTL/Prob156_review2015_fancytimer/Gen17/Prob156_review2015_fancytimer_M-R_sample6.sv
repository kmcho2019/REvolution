module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
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
    reg [3:0] bits_captured;
    reg [13:0] cycle_counter;
    reg [13:0] target_cycles;
    reg done_reg;

    // Continuous outputs
    assign counting = (state == COUNT) && !done_reg;
    assign done = done_reg;
    assign count = (state == COUNT) ? (target_cycles - cycle_counter) / 1000 : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            bits_captured <= 4'b0;
            cycle_counter <= 14'b0;
            target_cycles <= 14'b0;
            done_reg <= 1'b0;
        end else begin
            // Always shift in new data
            shift_reg <= {shift_reg[2:0], data};

            case (state)
                IDLE: begin
                    state <= PATTERN;
                    done_reg <= 1'b0;
                end

                PATTERN: begin
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bits_captured <= 4'b0;
                    end
                end

                CAPTURE: begin
                    if (bits_captured == 4'd3) begin
                        delay <= {delay[2:0], data};
                        target_cycles <= ({delay[2:0], data} + 1) * 1000;
                        cycle_counter <= 14'b0;
                        state <= COUNT;
                    end else begin
                        delay <= {delay[2:0], data};
                        bits_captured <= bits_captured + 1;
                    end
                end

                COUNT: begin
                    if (cycle_counter == target_cycles - 1) begin
                        done_reg <= 1'b1;
                        if (ack) begin
                            state <= IDLE;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
            endcase
        end
    end

endmodule