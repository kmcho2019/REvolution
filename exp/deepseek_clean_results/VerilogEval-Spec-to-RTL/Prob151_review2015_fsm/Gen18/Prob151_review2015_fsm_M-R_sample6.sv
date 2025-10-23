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
    localparam IDLE   = 4'b0001;
    localparam SHIFT  = 4'b0010;
    localparam COUNT  = 4'b0100;
    localparam DONE   = 4'b1000;

    reg [3:0] state, next_state;
    reg [3:0] pattern;
    reg [1:0] shift_count;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Pattern detection (shift register)
    always @(posedge clk) begin
        if (reset || (state != IDLE)) begin
            pattern <= 4'b0;
        end else begin
            pattern <= {pattern[2:0], data};
        end
    end

    // Shift counter
    always @(posedge clk) begin
        if (reset || (state != SHIFT)) begin
            shift_count <= 2'b0;
        end else begin
            shift_count <= shift_count + 1'b1;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (pattern == 4'b1101) ? SHIFT : IDLE;
            SHIFT: next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (pure combinational)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule