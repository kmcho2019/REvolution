module TopModule(
    input        clk,
    input        reset,
    output [3:0] q
);

reg [9:0] onehot_state;  // one-hot state: only one bit set representing count 1 to 10

// On reset, set the first count (bit 0)
// On each clock, rotate one-hot vector to the left (cyclic)
always @(posedge clk) begin
    if (reset)
        onehot_state <= 10'b0000000001;  // count=1
    else
        onehot_state <= {onehot_state[8:0], onehot_state[9]};
end

// Priority encoder to convert onehot_state to binary count (1 to 10)
reg [3:0] bin_count;
always @* begin
    case (onehot_state)
        10'b0000000001: bin_count = 4'd1;
        10'b0000000010: bin_count = 4'd2;
        10'b0000000100: bin_count = 4'd3;
        10'b0000001000: bin_count = 4'd4;
        10'b0000010000: bin_count = 4'd5;
        10'b0000100000: bin_count = 4'd6;
        10'b0001000000: bin_count = 4'd7;
        10'b0010000000: bin_count = 4'd8;
        10'b0100000000: bin_count = 4'd9;
        10'b1000000000: bin_count = 4'd10;
        default:        bin_count = 4'd0;  // Should never happen
    endcase
end

assign q = bin_count;

endmodule