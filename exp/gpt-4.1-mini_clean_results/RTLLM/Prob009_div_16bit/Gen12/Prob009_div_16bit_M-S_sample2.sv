module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    reg [15:0] dividend;
    reg [7:0]  divisor;

    // First combinational block: pass inputs to internal registers (combinational latch)
    always @(*) begin
        dividend = A;
        divisor  = B;
    end

    // Second combinational block: perform division
    always @(*) begin
        integer i;
        reg [8:0] remainder;
        reg [15:0] quotient;
        reg [8:0] divisor_ext;

        remainder   = 9'd0;
        quotient    = 16'd0;
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

        result = quotient;
        odd    = {8'd0, remainder[7:0]};
    end

endmodule