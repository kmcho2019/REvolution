module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // 10 state one-hot encoding for counts 0 to 9
    reg [9:0] state;

    // Next state logic: rotate one-hot bit to the left, wrapping from 9->0
    wire [9:0] next_state;
    assign next_state = {state[8:0], state[9]};

    // State transition and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 10'b0000000001; // start at count 0
        end else begin
            state <= next_state;
        end
    end

    // Output decoding: map the one-hot state to the binary count q (0..9)
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
            default:       q = 4'd0; // safe default
        endcase
    end

endmodule