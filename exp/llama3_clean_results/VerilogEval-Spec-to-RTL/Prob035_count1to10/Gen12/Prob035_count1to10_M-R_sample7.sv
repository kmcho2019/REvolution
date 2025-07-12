module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset count to 1 synchronously
    end else begin
        count <= next_count; // Update count with next_count
    end
end

always @(*) begin
    case (count)
        4'd1: next_count = 4'd2;
        4'd2: next_count = 4'd3;
        4'd3: next_count = 4'd4;
        4'd4: next_count = 4'd5;
        4'd5: next_count = 4'd6;
        4'd6: next_count = 4'd7;
        4'd7: next_count = 4'd8;
        4'd8: next_count = 4'd9;
        4'd9: next_count = 4'd10;
        4'd10: next_count = 4'd1;
        default: next_count = 4'd1; // Default to 1 if count is out of range
    endcase
end

assign q = count;

endmodule