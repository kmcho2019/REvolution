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

    // Pattern detection (only in IDLE state)
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
        end else if (state == IDLE) begin
            pattern <= {pattern[2:0], data};
        end else begin
            pattern <= 4'b0;
        end
    end

    // Shift counter (only in SHIFT state)
    always @(posedge clk) begin
        if (reset) begin
            shift_count <= 2'b0;
        end else if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end else begin
            shift_count <= 2'b0;
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= (pattern == 4'b1101) ? SHIFT : IDLE;
                SHIFT: state <= (shift_count == 2'd3) ? COUNT : SHIFT;
                COUNT: state <= done_counting ? DONE : COUNT;
                DONE:  state <= ack ? IDLE : DONE;
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule