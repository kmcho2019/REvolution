module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] bin_count = 4'd0; // Initialize binary counter to 0

always @(posedge clk) begin
    if (reset) begin
        bin_count <= 4'd0; // Reset to 0
    end else begin
        if (bin_count == 4'd10) begin
            bin_count <= 4'd1; // Wrap around to 1 (binary 0001)
        end else begin
            bin_count <= bin_count + 1; // Increment binary counter
        end
    end
end

// BCD decoder
always @(*) begin
    case (bin_count)
        4'd1: q = 4'd1;
        4'd2: q = 4'd2;
        4'd3: q = 4'd3;
        4'd4: q = 4'd4;
        4'd5: q = 4'd5;
        4'd6: q = 4'd6;
        4'd7: q = 4'd7;
        4'd8: q = 4'd8;
        4'd9: q = 4'd9;
        4'd10: q = 4'd10;
        default: q = 4'd1; // Default to 1 for any other value
    endcase
end

endmodule