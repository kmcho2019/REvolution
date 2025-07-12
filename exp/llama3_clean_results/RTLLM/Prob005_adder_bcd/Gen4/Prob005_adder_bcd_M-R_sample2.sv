module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition and include carry-in
wire [4:0] sum_bin = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

// Determine carry-out
assign Cout = (sum_bin > 9) | sum_bin[4];

// Apply BCD correction if necessary
reg [3:0] sum_corrected;
always @(*) begin
    if (sum_bin <= 9) begin
        sum_corrected = sum_bin[3:0];
    end else begin
        sum_corrected = sum_bin[3:0] + 4'd6;
    end
end

assign Sum = sum_corrected;

endmodule