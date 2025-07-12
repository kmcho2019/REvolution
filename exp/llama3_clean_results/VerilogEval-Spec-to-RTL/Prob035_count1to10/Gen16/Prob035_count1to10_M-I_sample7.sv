module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset count to 1 synchronously
    end else begin
        case (count)
            4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9: count <= count + 1;
            4'd10: count <= 4'd1;
            default: count <= 4'd1; // This should not occur but is included for completeness
        endcase
    end
end

assign q = count;

endmodule