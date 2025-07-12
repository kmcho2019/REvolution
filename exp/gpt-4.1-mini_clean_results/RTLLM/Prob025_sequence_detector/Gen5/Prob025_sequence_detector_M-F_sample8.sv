module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding representing sequence progress:
    // STATE_0: no bits matched
    // STATE_1: matched '1'
    // STATE_2: matched "10"
    // STATE_3: matched "100"
    localparam STATE_0 = 2'd0;
    localparam STATE_1 = 2'd1;
    localparam STATE_2 = 2'd2;
    localparam STATE_3 = 2'd3;

    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            STATE_0: next_state = data_in ? STATE_1 : STATE_0;
            STATE_1: next_state = data_in ? STATE_1 : STATE_2;
            STATE_2: next_state = data_in ? STATE_3 : STATE_0;
            STATE_3: next_state = data_in ? STATE_1 : STATE_2;
            default: next_state = STATE_0;
        endcase
    end

    // Sequential state update and output generation
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= STATE_0;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Assert sequence_detected when final '1' completes the sequence "1001"
            sequence_detected <= (state == STATE_3) && data_in;
        end
    end

endmodule