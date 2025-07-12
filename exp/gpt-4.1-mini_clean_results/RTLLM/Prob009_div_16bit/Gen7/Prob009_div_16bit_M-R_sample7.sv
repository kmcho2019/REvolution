module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

    // Function performing division: returns {quotient, remainder}
    function [31:0] div_func;
        input [15:0] dividend;
        input [7:0]  divisor;
        integer i;
        reg [8:0] remainder;
        reg [15:0] quotient;
        reg [8:0] divisor_ext;
    begin
        remainder = 9'd0;
        quotient  = 16'd0;
        divisor_ext = {1'b0, divisor};

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], dividend[i]};
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        div_func = {quotient, {7'd0, remainder[8:0]}};
    end
    endfunction

    wire [31:0] div_out;
    assign div_out = div_func(A, B);

    assign result = div_out[31:16];
    assign odd    = div_out[15:0];

endmodule