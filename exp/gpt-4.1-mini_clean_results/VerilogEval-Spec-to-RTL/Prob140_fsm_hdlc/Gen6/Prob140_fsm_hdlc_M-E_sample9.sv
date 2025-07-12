module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State definition: count of consecutive ones (0 to 6)
    // 3 bits are enough to count 0..6
    reg [2:0] count_ones, next_count;

    // Next state logic
    always @(*) begin
        case (count_ones)
            3'd0: next_count = (in) ? 3'd1 : 3'd0;
            3'd1: next_count = (in) ? 3'd2 : 3'd0;
            3'd2: next_count = (in) ? 3'd3 : 3'd0;
            3'd3: next_count = (in) ? 3'd4 : 3'd0;
            3'd4: next_count = (in) ? 3'd5 : 3'd0;
            3'd5: next_count = (in) ? 3'd6 : 3'd0;
            3'd6: next_count = (in) ? 3'd6 : 3'd0; // saturate at 6 ones if in=0 reset to 0
            default: next_count = 3'd0;
        endcase
    end

    // Moore outputs are based on previous state and current input, but outputs asserted one cycle after
    // So we must detect transitions that trigger disc, flag, err and register them

    // We use the previous count and input to generate disc, flag, err at next clock
    // Because outputs are to be asserted one cycle after condition occurs

    // Registers to hold current input and count for output generation next cycle
    reg prev_in;

    always @(posedge clk) begin
        if (reset) begin
            count_ones <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
            prev_in <= 1'b0;
        end else begin
            // Update state
            count_ones <= next_count;
            prev_in <= in;

            // Clear outputs by default
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;

            // Evaluate outputs based on previous count and previous input (which now reflect last cycle's)
            case (count_ones)
                3'd5: begin
                    // if previously we had 5 ones, now after input cycle:
                    // If last input was 0, disc output asserted (0 after 5 ones)
                    if (prev_in == 1'b0)
                        disc <= 1'b1;
                end
                3'd6: begin
                    // If previously had 6 ones
                    // last input = 0 -> flag output
                    if (prev_in == 1'b0)
                        flag <= 1'b1;
                    else if (prev_in == 1'b1)
                        err <= 1'b1;
                end
                default: begin
                    // no output
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err <= 1'b0;
                end
            endcase
        end
    end

endmodule