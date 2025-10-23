module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg [1:0] comparison_result
);

always @(*)
begin
    if (A > B) begin
        comparison_result = 2'b10;
    end else if (A < B) begin
        comparison_result = 2'b00;
    end else begin
        comparison_result = 2'b01;
    end
end

endmodule