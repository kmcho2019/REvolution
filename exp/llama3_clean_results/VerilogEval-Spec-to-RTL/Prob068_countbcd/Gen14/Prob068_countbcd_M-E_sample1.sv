module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (count == 16'd9999) begin
            count <= 16'd0;
        end else begin
            count <= count + 1;
        end
    end
end

// Generate BCD digits
wire [3:0] ones = count % 10;
wire [3:0] tens = (count / 10) % 10;
wire [3:0] hundreds = (count / 100) % 10;
wire [3:0] thousands = count / 1000;

assign q = {thousands, hundreds, tens, ones};

// Generate enable signals
assign ena[0] = (ones == 4'd9)? 1'b1 : 1'b0;
assign ena[1] = (tens == 4'd9 && ena[0] == 1'b1)? 1'b1 : 1'b0;
assign ena[2] = (hundreds == 4'd9 && ena[1] == 1'b1 && ena[0] == 1'b1)? 1'b1 : 1'b0;

endmodule