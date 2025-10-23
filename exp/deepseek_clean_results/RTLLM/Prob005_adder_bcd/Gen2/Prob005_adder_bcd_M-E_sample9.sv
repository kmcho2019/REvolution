module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] raw_sum = A + B + Cin;
    wire [4:0] precorrected_sum = raw_sum + 5'b00110;
    
    // Fast carry prediction (sum > 9 or carry generated)
    wire correction_needed = (raw_sum[4]) | 
                           (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
    
    always @(*) begin
        if (correction_needed) begin
            Sum = precorrected_sum[3:0];
            Cout = precorrected_sum[4];
        end
        else begin
            Sum = raw_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule