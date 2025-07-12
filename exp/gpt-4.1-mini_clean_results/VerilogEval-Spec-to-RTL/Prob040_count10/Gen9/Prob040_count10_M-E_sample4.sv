module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] state;

// One-hot encoding of count: bit 0 represents count 0, bit 9 represents count 9.

always @(posedge clk) begin
    if (reset)
        state <= 10'b0000000001; // count = 0
    else begin
        // Rotate left with wraparound
        if (state[9])
            state <= 10'b0000000001;
        else
            state <= state << 1;
    end
end

// Decode one-hot state to binary count
always @(*) begin
    case(state)
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
        default:       q = 4'd0; // default safe state
    endcase
end

endmodule