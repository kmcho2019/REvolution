module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    // Function to perform combinational division
    function automatic void div_func(
        input [15:0] dividend,
        input [7:0]  divisor,
        output [15:0] quotient,
        output [15:0] remainder
    );
        integer i;
        reg [8:0] rem;
        reg [15:0] quot;
        reg [8:0] divisor_ext;

        begin
            rem = 9'd0;
            quot = 16'd0;
            divisor_ext = {1'b0, divisor};

            for (i = 15; i >= 0; i = i - 1) begin
                rem = {rem[7:0], dividend[i]};
                if (rem >= divisor_ext) begin
                    rem = rem - divisor_ext;
                    quot[i] = 1'b1;
                end else begin
                    quot[i] = 1'b0;
                end
            end

            div_func = 0; // dummy to avoid synthesis warning for function with void return
            quotient = quot;
            remainder = {8'b0, rem[7:0]};
        end
    endfunction

    always @(*) begin
        div_func(A, B, result, odd);
    end

endmodule