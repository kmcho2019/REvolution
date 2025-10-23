module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [13:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 14'd0;
    end else begin
        if (count == 14'd9999) begin
            count <= 14'd0;
        end else begin
            count <= count + 1;
        end
    end
end

// Decode count into BCD digits
wire [3:0] thousands = count[13:12] == 2'b01 ? 4'd9 : (count[13:12] == 2'b10 ? 4'd9 + 1 : count[13:12]);
wire [3:0] hundreds = count[11:10] == 2'b01 ? 4'd9 : (count[11:10] == 2'b10 ? 4'd9 + 1 : count[11:10]);
wire [3:0] tens = count[9:8] == 2'b01 ? 4'd9 : (count[9:8] == 2'b10 ? 4'd9 + 1 : count[9:8]);
wire [3:0] ones = count[7:6] == 2'b01 ? 4'd9 : (count[7:6] == 2'b10 ? 4'd9 + 1 : count[7:6]);

// Generate enable signals
wire ones_carry = count[7:6] == 2'b11 && count[5:0] == 6'd59;
wire tens_carry = count[9:6] == 5'b10011 && count[5:0] == 6'd59;
wire hundreds_carry = count[11:6] == 7'b1000111 && count[5:0] == 6'd59;

assign q = {thousands, hundreds, tens, ones};
assign ena = {hundreds_carry, tens_carry, ones_carry};

endmodule