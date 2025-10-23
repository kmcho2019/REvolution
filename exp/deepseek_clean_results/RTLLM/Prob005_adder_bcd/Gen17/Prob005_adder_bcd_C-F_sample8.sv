module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    // Compute initial sum with carry-out (5-bit)
    wire [4:0] sum_ext = A + B + Cin;
    
    // Optimized overflow detection using direct comparison
    wire overflow = (sum_ext[3:0] > 4'd9) | sum_ext[4];

    // Power-optimized correction logic
    always @(*) begin
        if (overflow) begin
            Sum = sum_ext[3:0] + 4'd6;
            Cout = 1'b1;
        end else begin
            Sum = sum_ext[3:0];
            Cout = 1'b0;
        end
    end

endmodule