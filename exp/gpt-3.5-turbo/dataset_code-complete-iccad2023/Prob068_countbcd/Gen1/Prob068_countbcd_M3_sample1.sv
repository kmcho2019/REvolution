module BCD_counter (
    input clk,
    input reset,
    output reg [3:1] ena,
    output reg [15:0] q
);

    reg [3:0] digit1, digit2, digit3, digit4;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            digit1 <= 4'b0000;
            digit2 <= 4'b0000;
            digit3 <= 4'b0000;
            digit4 <= 4'b0000;
            q <= 16'b0000;
        end else begin
            digit1 <= (ena[1]) ? (digit1 == 4'b1001 ? 4'b0000 : digit1 + 4'b0001) : digit1;
            digit2 <= (ena[2]) ? (digit2 == 4'b1001 ? 4'b0000 : digit2 + 4'b0001) : digit2;
            digit3 <= (ena[3]) ? (digit3 == 4'b1001 ? 4'b0000 : digit3 + 4'b0001) : digit3;
            digit4 <= (digit4 == 4'b1001 ? 4'b0000 : digit4 + 4'b0001);
            q <= {digit1, digit2, digit3, digit4};
        end
    end

endmodule