module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] remainder // 16-bit remainder (lower 8 bits valid)
);

    // First "block": continuous assignment as combinational input stage (replace reg copy)
    wire [15:0] a_wire = A;
    wire [7:0]  b_wire = B;

    // Second always block: combinational division logic
    always @(*) begin
        integer i;
        reg [8:0] rem;           // 9-bit remainder for subtraction (1 extra bit)
        reg [15:0] quot;
        reg [8:0] divisor_ext;

        rem = 9'd0;
        quot = 16'd0;
        divisor_ext = {1'b0, b_wire}; // zero-extend divisor to 9 bits

        for (i = 15; i >= 0; i = i - 1) begin
            rem = {rem[7:0], a_wire[i]};
            if (rem >= divisor_ext) begin
                rem = rem - divisor_ext;
                quot[i] = 1'b1;
            end else begin
                quot[i] = 1'b0;
            end
        end

        result = quot;
        remainder = {8'd0, rem[7:0]};
    end

endmodule