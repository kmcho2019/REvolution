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
    localparam IDLE      = 4'b0001;
    localparam SHIFT     = 4'b0010;
    localparam COUNTING  = 4'b0100;
    localparam DONE      = 4'b1000;

    reg [3:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // State transitions and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 2'b0;
            pattern <= 4'b0;
        end else begin
            case (1'b1) // Synthesis will optimize this
                state[0]: begin // IDLE
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        pattern <= 4'b0; // Clear pattern after detection
                    end
                end

                state[1]: begin // SHIFT
                    shift_cnt <= shift_cnt + 1;
                    if (shift_cnt == 2'b11) begin
                        state <= COUNTING;
                        shift_cnt <= 2'b0;
                    end
                end

                state[2]: begin // COUNTING
                    if (done_counting)
                        state <= DONE;
                end

                state[3]: begin // DONE
                    if (ack)
                        state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = state[1]; // SHIFT state
    assign counting  = state[2]; // COUNTING state
    assign done      = state[3]; // DONE state

endmodule