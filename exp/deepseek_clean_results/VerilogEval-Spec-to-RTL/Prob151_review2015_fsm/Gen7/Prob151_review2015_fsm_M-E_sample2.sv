module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // One-hot state encoding
    localparam S_IDLE   = 4'b0001;
    localparam S_SHIFT  = 4'b0010;
    localparam S_COUNT  = 4'b0100;
    localparam S_DONE   = 4'b1000;

    reg [3:0] state, next_state;
    reg [1:0] shift_counter;
    reg [3:0] data_window;
    wire pattern_match;

    // Sliding window pattern detector (1101)
    always @(posedge clk) begin
        if (reset)
            data_window <= 4'b0;
        else if (state == S_IDLE)
            data_window <= {data_window[2:0], data};
    end

    assign pattern_match = (data_window == 4'b1101) && (state == S_IDLE);

    // Shift counter (0-3)
    always @(posedge clk) begin
        if (reset || state != S_SHIFT)
            shift_counter <= 2'b0;
        else
            shift_counter <= shift_counter + 1;
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_IDLE:  next_state = pattern_match ? S_SHIFT : S_IDLE;
            S_SHIFT: next_state = (shift_counter == 2'b11) ? S_COUNT : S_SHIFT;
            S_COUNT: next_state = done_counting ? S_DONE : S_COUNT;
            S_DONE:  next_state = ack ? S_IDLE : S_DONE;
            default: next_state = S_IDLE;
        endcase
    end

    // Registered outputs for clean transitions
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            shift_ena <= (next_state == S_SHIFT);
            counting <= (next_state == S_COUNT);
            done <= (next_state == S_DONE);
        end
    end

endmodule