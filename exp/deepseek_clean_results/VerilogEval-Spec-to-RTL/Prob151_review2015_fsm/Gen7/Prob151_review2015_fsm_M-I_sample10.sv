module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam SHIFT = 3'b010;
    localparam COUNT = 3'b100;
    
    reg [2:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 0;
            pattern <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        shift_cnt <= 0;
                        pattern <= 0;  // Clear pattern for next detection
                    end
                end

                SHIFT: begin
                    if (shift_cnt == 2'b11)
                        state <= COUNT;
                    shift_cnt <= shift_cnt + 1;
                end

                COUNT: begin
                    if (done_counting)
                        state <= IDLE;  // Transition directly to IDLE when done
                end

                default: state <= IDLE;  // Safety net
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == COUNT) && done_counting;

endmodule