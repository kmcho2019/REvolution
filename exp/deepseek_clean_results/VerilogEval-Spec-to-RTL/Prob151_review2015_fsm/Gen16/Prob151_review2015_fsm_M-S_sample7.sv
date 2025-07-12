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

    // State encoding
    localparam IDLE   = 2'b00;
    localparam SHIFT  = 2'b01;
    localparam COUNT  = 2'b10;
    localparam DONE   = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern;
    reg [1:0] shift_count;

    // Pattern detection (only shifts in IDLE state)
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
        end else if (state == IDLE) begin
            pattern <= {pattern[2:0], data};
        end else begin
            pattern <= 4'b0;
        end
    end

    // Shift counter and state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                end
                SHIFT: begin
                    if (shift_count == 2'd3) begin
                        state <= COUNT;
                    end
                    shift_count <= shift_count + 1'b1;
                end
                COUNT: begin
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
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule