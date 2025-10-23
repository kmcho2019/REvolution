module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Synchronous reset to 1
    end else begin
        case (count)
            4'd1: count <= 4'd2;
            4'd2: count <= 4'd3;
            4'd3: count <= 4'd4;
            4'd4: count <= 4'd5;
            4'd5: count <= 4'd6;
            4'd6: count <= 4'd7;
            4'd7: count <= 4'd8;
            4'd8: count <= 4'd9;
            4'd9: count <= 4'd10;
            4'd10: count <= 4'd1; // Wrap around to 1
            default: count <= 4'd1; // Default case for invalid counts
        endcase
    end
end

assign q = count;

endmodule