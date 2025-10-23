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

    // One-hot encoded states (8 bits to cover states):
    // 0: SEARCH0, 1: SEARCH1, 2: SEARCH2, 3: SEARCH3, 4: SHIFT, 5: COUNT, 6: DONE
    localparam SEARCH0 = 8'b0000_0001;
    localparam SEARCH1 = 8'b0000_0010;
    localparam SEARCH2 = 8'b0000_0100;
    localparam SEARCH3 = 8'b0000_1000;
    localparam SHIFT   = 8'b0001_0000;
    localparam COUNT   = 8'b0010_0000;
    localparam DONE    = 8'b0100_0000;

    reg [7:0] state, next_state;
    reg [1:0] shift_count; // counts 0 to 3 for 4 shift cycles

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            // Update shift_count only in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2;
            SEARCH3: next_state = (data) ? SHIFT : SEARCH0;

            SHIFT:   next_state = (shift_count == 2'd3) ? COUNT : SHIFT;

            COUNT:   next_state = (done_counting) ? DONE : COUNT;

            DONE:    next_state = (ack) ? SEARCH0 : DONE;

            default: next_state = SEARCH0;
        endcase
    end

    // Output logic (Moore outputs)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule