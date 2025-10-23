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

    // Binary state encoding
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [2:0] shift_count; // Tracks shift cycles (0-3)
    reg [2:0] pattern;     // Shift register for pattern detection

    // Pattern detection
    wire pattern_match = (pattern == 3'b110) && (data == 1'b1);

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'b0;
            pattern <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[1:0], data};
                    if (pattern_match) begin
                        state <= SHIFT;
                        shift_count <= 3'b0;
                    end
                end

                SHIFT: begin
                    shift_count <= shift_count + 1;
                    if (shift_count == 3'b11) begin
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    if (done_counting) begin
                        state <= DONE;
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
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule