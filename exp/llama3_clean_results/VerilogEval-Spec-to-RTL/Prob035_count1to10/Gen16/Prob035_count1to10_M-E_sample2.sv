module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset to 1
    end else if (count == 4'd10) begin
        count <= 4'd1; // Wrap around to 1 after reaching 10
    end else begin
        count <= count + 1; // Increment
    end
end

// Decoding logic to ensure the output matches the 1 to 10 sequence
always @(*) begin
    case(count)
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
        default: q = 4'd1; // For counts beyond 10, default to 1
    endcase
end

endmodule