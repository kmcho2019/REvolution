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

    // Simple state encoding
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_count;
    reg [3:0] pattern;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'b0;
            pattern <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data and check for pattern 1101
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                end

                SHIFT: begin
                    shift_count <= shift_count + 1;
                    if (shift_count == 2'b11) begin
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