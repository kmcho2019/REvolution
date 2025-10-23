module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot encoded states
    localparam SEARCH0 = 7'b0000001;
    localparam SEARCH1 = 7'b0000010;
    localparam SEARCH2 = 7'b0000100;
    localparam SEARCH3 = 7'b0001000;
    localparam SHIFT   = 7'b0010000;
    localparam COUNT   = 7'b0100000;
    localparam DONE    = 7'b1000000;

    reg [6:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        next_state = SEARCH0; // default
        case (state)
            SEARCH0: next_state = data ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = data ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2; // Allow overlapping pattern by staying in SEARCH2 if data=1
            SEARCH3: next_state = data ? SHIFT : SEARCH0;
            SHIFT: begin
                if (shift_count == 3) // shift_count from 0 to 3 counts 4 cycles
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

    // State flip-flops
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH0;
        else
            state <= next_state;
    end

    // 2-bit shift counter for counting 4 shifts
    reg [1:0] shift_count;

    // shift_count increments only during SHIFT state, resets otherwise
    always @(posedge clk) begin
        if (reset)
            shift_count <= 2'd0;
        else if (state == SHIFT)
            shift_count <= shift_count + 1'b1;
        else
            shift_count <= 2'd0;
    end

    // Outputs: purely combinational from state (one-hot encoding)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule