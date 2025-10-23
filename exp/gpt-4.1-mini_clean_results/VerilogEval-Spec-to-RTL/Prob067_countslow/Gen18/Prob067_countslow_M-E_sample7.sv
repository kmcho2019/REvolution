module TopModule (
    input        clk,
    input        reset,
    input        slowena,
    output reg [3:0] q
);

    // One-hot states for counts 0 to 9
    reg [9:0] state, next_state;

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 10'b0000000001; // count = 0
        else if (slowena)
            state <= next_state;
        else
            state <= state; // hold current state if slowena is low
    end

    // Next state logic: shift one-hot bit left, wrap around from bit 9 to bit 0
    always @(*) begin
        case (state)
            10'b0000000001: next_state = 10'b0000000010; // 0->1
            10'b0000000010: next_state = 10'b0000000100; // 1->2
            10'b0000000100: next_state = 10'b0000001000; // 2->3
            10'b0000001000: next_state = 10'b0000010000; // 3->4
            10'b0000010000: next_state = 10'b0000100000; // 4->5
            10'b0000100000: next_state = 10'b0001000000; // 5->6
            10'b0001000000: next_state = 10'b0010000000; // 6->7
            10'b0010000000: next_state = 10'b0100000000; // 7->8
            10'b0100000000: next_state = 10'b1000000000; // 8->9
            10'b1000000000: next_state = 10'b0000000001; // 9->0 wrap
            default:       next_state = 10'b0000000001; // default reset to 0
        endcase
    end

    // Output decoding from one-hot state to 4-bit binary count
    always @(*) begin
        case (state)
            10'b0000000001: q = 4'd0;
            10'b0000000010: q = 4'd1;
            10'b0000000100: q = 4'd2;
            10'b0000001000: q = 4'd3;
            10'b0000010000: q = 4'd4;
            10'b0000100000: q = 4'd5;
            10'b0001000000: q = 4'd6;
            10'b0010000000: q = 4'd7;
            10'b0100000000: q = 4'd8;
            10'b1000000000: q = 4'd9;
            default:       q = 4'd0;
        endcase
    end

endmodule