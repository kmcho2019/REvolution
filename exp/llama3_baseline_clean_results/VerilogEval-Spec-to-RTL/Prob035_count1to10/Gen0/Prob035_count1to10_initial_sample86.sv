module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001;  // Reset to 1
    end else begin
        case (count)
            4'b0001: count <= 4'b0010;  // Count from 1 to 2
            4'b0010: count <= 4'b0011;  // Count from 2 to 3
            4'b0011: count <= 4'b0100;  // Count from 3 to 4
            4'b0100: count <= 4'b0101;  // Count from 4 to 5
            4'b0101: count <= 4'b0110;  // Count from 5 to 6
            4'b0110: count <= 4'b0111;  // Count from 6 to 7
            4'b0111: count <= 4'b1000;  // Count from 7 to 8
            4'b1000: count <= 4'b1001;  // Count from 8 to 9
            4'b1001: count <= 4'b1010;  // Count from 9 to 10
            4'b1010: count <= 4'b0001;  // Count from 10 back to 1
            default: count <= 4'b0001;  // In case of invalid count, reset to 1
        endcase
    end
end

assign q = count;

endmodule