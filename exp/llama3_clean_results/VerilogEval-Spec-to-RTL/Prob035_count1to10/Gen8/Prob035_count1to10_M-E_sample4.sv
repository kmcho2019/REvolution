module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] johnson_count;

always @(posedge clk) begin
    if (reset) begin
        johnson_count <= 4'b1000; // Reset to the first state of the sequence
    end else begin
        johnson_count <= {johnson_count[2:0], johnson_count[3]}; // Shift and wrap-around
    end
end

always @(*) begin
    case (johnson_count)
        4'b1000: q = 4'd1;
        4'b1100: q = 4'd2;
        4'b1110: q = 4'd3;
        4'b1111: q = 4'd4;
        4'b0111: q = 4'd5;
        4'b0011: q = 4'd6;
        4'b0001: q = 4'd7;
        4'b1001: q = 4'd8;
        4'b1101: q = 4'd9;
        4'b1011: q = 4'd10;
        default: q = 4'd1; // Default to 1 to handle any unexpected state
    endcase
end

endmodule