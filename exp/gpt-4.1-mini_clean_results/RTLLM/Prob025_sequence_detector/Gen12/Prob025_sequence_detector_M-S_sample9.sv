module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // States represent how many bits of "1001" matched so far:
    // 0 - no match, 1 - matched '1', 2 - matched '10', 3 - matched '100', 4 - matched '1001'
    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            3'd0: next_state = data_in ? 3'd1 : 3'd0;
            3'd1: next_state = data_in ? 3'd1 : 3'd2;
            3'd2: next_state = data_in ? 3'd1 : 3'd3;
            3'd3: next_state = data_in ? 3'd4 : 3'd0;
            3'd4: next_state = data_in ? 3'd1 : 3'd0;
            default: next_state = 3'd0;
        endcase
    end

    always @(posedge clk) begin
        if (!reset_n) begin
            state <= 3'd0;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= (next_state == 3'd4);
        end
    end

endmodule