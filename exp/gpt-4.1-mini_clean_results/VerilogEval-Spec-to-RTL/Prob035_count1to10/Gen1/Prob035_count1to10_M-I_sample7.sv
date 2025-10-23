module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

    // One-hot state encoding: 10 flip-flops, each corresponds to count 1..10
    reg [9:0] state, next_state;

    // State transition: shift the '1' bit to next position, wrapping after 10
    always @(*) begin
        next_state = 10'b0;
        case (state)
            10'b0000000001: next_state = 10'b0000000010; // 1 -> 2
            10'b0000000010: next_state = 10'b0000000100; // 2 -> 3
            10'b0000000100: next_state = 10'b0000001000; // 3 -> 4
            10'b0000001000: next_state = 10'b0000010000; // 4 -> 5
            10'b0000010000: next_state = 10'b0000100000; // 5 -> 6
            10'b0000100000: next_state = 10'b0001000000; // 6 -> 7
            10'b0001000000: next_state = 10'b0010000000; // 7 -> 8
            10'b0010000000: next_state = 10'b0100000000; // 8 -> 9
            10'b0100000000: next_state = 10'b1000000000; // 9 -> 10
            10'b1000000000: next_state = 10'b0000000001; // 10 -> 1
            default:       next_state = 10'b0000000001; // safety default to 1
        endcase
    end

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 10'b0000000001; // count=1
        else
            state <= next_state;
    end

    // Combinational logic to decode one-hot state into binary count (1 to 10)
    always @(*) begin
        case (state)
            10'b0000000001: q = 4'd1;
            10'b0000000010: q = 4'd2;
            10'b0000000100: q = 4'd3;
            10'b0000001000: q = 4'd4;
            10'b0000010000: q = 4'd5;
            10'b0000100000: q = 4'd6;
            10'b0001000000: q = 4'd7;
            10'b0010000000: q = 4'd8;
            10'b0100000000: q = 4'd9;
            10'b1000000000: q = 4'd10;
            default:        q = 4'd1; // safety default
        endcase
    end

endmodule