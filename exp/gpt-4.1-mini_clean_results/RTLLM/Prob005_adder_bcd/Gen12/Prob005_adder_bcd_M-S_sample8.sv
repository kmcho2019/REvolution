module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);

    reg [4:0] sum_raw;
    reg [4:0] sum_corr;

    always @* begin
        // Binary addition
        sum_raw = A + B + Cin;

        // Check if correction needed (sum_raw > 9)
        if (sum_raw > 5'd9) begin
            sum_corr = sum_raw + 5'd6; // Add correction 6 for BCD
        end else begin
            sum_corr = sum_raw;
        end

        Sum  = sum_corr[3:0];
        Cout = sum_corr[4];
    end

endmodule