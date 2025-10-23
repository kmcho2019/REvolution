module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] state; // one-hot state: only one bit is '1' representing counts 0 to 9

    // Next state logic is simple rotation of the '1' bit
    wire [9:0] next_state = {state[8:0], state[9]};

    always @(posedge clk) begin
        if (reset)
            state <= 10'b0000000001; // count 0
        else
            state <= next_state;
    end

    // Decode one-hot to binary count
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
            default: q = 4'd0; // should never happen, safe reset
        endcase
    end

endmodule