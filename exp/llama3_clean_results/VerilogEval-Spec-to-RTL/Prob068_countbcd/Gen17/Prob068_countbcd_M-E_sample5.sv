module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [11:0] count;
reg [3:0] ones, tens, hundreds, thousands;
reg ones_carry, tens_carry, hundreds_carry;

always @(posedge clk) begin
    if (reset) begin
        count <= 12'd0;
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (count == 12'd9999) begin
            count <= 12'd0;
        end else begin
            count <= count + 1;
        end
        
        ones <= count % 10;
        tens <= (count / 10) % 10;
        hundreds <= (count / 100) % 10;
        thousands <= count / 1000;
    end
end

assign q = {thousands, hundreds, tens, ones};
assign ones_carry = (count % 10 == 9);
assign tens_carry = ((count / 10) % 10 == 9);
assign hundreds_carry = ((count / 100) % 10 == 9);
assign ena = {hundreds_carry, tens_carry, ones_carry};

endmodule