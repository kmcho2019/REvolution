module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam STATE_0 = 2'd0;  // No bits matched
    localparam STATE_1 = 2'd1;  // Matched '1'
    localparam STATE_2 = 2'd2;  // Matched "10"
    localparam STATE_3 = 2'd3;  // Matched "100"

    reg [1:0] state, next_state;

    // Next-state logic combinational
    always @(*) begin
        case (state)
            STATE_0: next_state = data_in ? STATE_1 : STATE_0;
            STATE_1: next_state = data_in ? STATE_1 : STATE_2;
            STATE_2: next_state = data_in ? STATE_3 : STATE_0;
            STATE_3: next_state = data_in ? STATE_1 : STATE_2;
            default: next_state = STATE_0;
        endcase
    end

    // State and output registers with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= STATE_0;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected asserted when final '1' detected at STATE_3
            sequence_detected <= (state == STATE_3) && data_in;
        end
    end

endmodule