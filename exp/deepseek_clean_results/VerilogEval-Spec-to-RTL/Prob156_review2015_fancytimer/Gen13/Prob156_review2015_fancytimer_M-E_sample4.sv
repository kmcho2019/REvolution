module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // Phase tracking
    localparam PH_WAIT = 0;
    localparam PH_PATTERN_MATCHED = 1;
    localparam PH_COLLECT_DELAY = 2;
    localparam PH_COUNTING = 3;
    localparam PH_DONE = 4;

    reg [2:0] phase;
    reg [3:0] pattern_shifter;
    reg [3:0] delay_shifter;
    reg [3:0] delay_value;
    reg [13:0] cycle_counter; // 14 bits for max 15*1000=15000 cycles
    reg [9:0] sub_counter;    // Counts 0-999 for each delay step

    // Pattern detection
    always @(posedge clk) begin
        if (reset) begin
            phase <= PH_WAIT;
            pattern_shifter <= 4'b0;
            delay_shifter <= 4'b0;
            delay_value <= 4'b0;
            cycle_counter <= 0;
            sub_counter <= 0;
            count <= 4'b0;
        end else begin
            case (phase)
                PH_WAIT: begin
                    pattern_shifter <= {pattern_shifter[2:0], data};
                    if (pattern_shifter == 4'b1101) begin
                        phase <= PH_PATTERN_MATCHED;
                    end
                end

                PH_PATTERN_MATCHED: begin
                    phase <= PH_COLLECT_DELAY;
                    delay_shifter <= 4'b0;
                end

                PH_COLLECT_DELAY: begin
                    delay_shifter <= {delay_shifter[2:0], data};
                    if (cycle_counter == 3) begin
                        delay_value <= {delay_shifter[2:0], data};
                        phase <= PH_COUNTING;
                        cycle_counter <= (delay_value + 1) * 1000 - 1;
                        sub_counter <= 0;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                PH_COUNTING: begin
                    if (cycle_counter > 0) begin
                        cycle_counter <= cycle_counter - 1;
                        sub_counter <= sub_counter + 1;
                        if (sub_counter == 999) begin
                            sub_counter <= 0;
                            count <= count - 1;
                        end
                    end else begin
                        phase <= PH_DONE;
                        count <= 4'b0;
                    end
                end

                PH_DONE: begin
                    if (ack) begin
                        phase <= PH_WAIT;
                        pattern_shifter <= 4'b0;
                        cycle_counter <= 0;
                    end
                end
            endcase
        end
    end

    // Output generation
    assign counting = (phase == PH_COUNTING);
    assign done = (phase == PH_DONE);

    // Initialize count with delay_value when starting to count
    always @(posedge clk) begin
        if (phase == PH_COLLECT_DELAY && cycle_counter == 3) begin
            count <= {delay_shifter[2:0], data};
        end
    end

endmodule