module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [9:0] one_hot;  // One-hot register: only one bit set at a time, positions 0..9

// On reset, set count at position 0 (count=0)
// Otherwise, rotate the '1' bit to the next position, wrapping after 9 back to 0
always @(posedge clk) begin
    if (reset)
        one_hot <= 10'b0000000001;
    else
        one_hot <= {one_hot[8:0], one_hot[9]};
end

// Decode one_hot to binary count
// Since only one bit is set, the binary output is the index of that bit
always @(*) begin
    case (one_hot)
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
        default:       q = 4'd0; // Safety default
    endcase
end

endmodule