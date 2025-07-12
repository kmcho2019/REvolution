module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] johnson_count;

always @(posedge clk) begin
    if (reset) begin
        johnson_count <= 4'b1000; // Reset to state 8, which corresponds to count 0
    end else begin
        // Shift the bits to the right and add the inverted MSB to the LSB
        johnson_count <= {~johnson_count[3], johnson_count[3:1]};
    end
end

// Decoding logic to convert Johnson counter states to decade counter outputs
always @(*) begin
    case (johnson_count)
        4'b1000: q = 4'd0; // State 8
        4'b1100: q = 4'd1; // State 7
        4'b1110: q = 4'd2; // State 6
        4'b1111: q = 4'd3; // State 5
        4'b0111: q = 4'd4; // State 4
        4'b0011: q = 4'd5; // State 3
        4'b0001: q = 4'd6; // State 2
        4'b1001: q = 4'd7; // State 1
        4'b1101: q = 4'd8; // State 0 (wrap-around)
        4'b1110: q = 4'd9; // State 6 (wrap-around)
        default: q = 4'd0; // Default to 0 for any other state
    endcase
end

endmodule