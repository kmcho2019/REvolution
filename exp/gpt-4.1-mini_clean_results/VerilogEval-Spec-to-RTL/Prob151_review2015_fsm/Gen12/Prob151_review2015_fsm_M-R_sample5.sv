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

    // One-hot state encoding (7 bits)
    localparam SEARCH0 = 7'b0000001;
    localparam SEARCH1 = 7'b0000010;
    localparam SEARCH2 = 7'b0000100;
    localparam SEARCH3 = 7'b0001000;
    localparam SHIFT   = 7'b0010000;
    localparam COUNT   = 7'b0100000;
    localparam DONE    = 7'b1000000;

    reg [6:0] state, next_state;

    // 3-bit shift counter for SHIFT state (0 to 3)
    reg [2:0] shift_count;

    // State register and shift counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 3'd1;
            else
                shift_count <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SEARCH0: begin
                // Wait for first '1' to start pattern detection
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            SEARCH1: begin
                // matched '1', next '1' advances, else reset
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            SEARCH2: begin
                // matched "11", next bit 0 advances, else remain or reset
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2; // still matched '11' as input '1' again
            end
            SEARCH3: begin
                // matched "110", next bit 1 completes pattern
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end
            SHIFT: begin
                if (shift_count == 3'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH0;
        endcase
    end

    // Output logic: outputs asserted if in corresponding state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule