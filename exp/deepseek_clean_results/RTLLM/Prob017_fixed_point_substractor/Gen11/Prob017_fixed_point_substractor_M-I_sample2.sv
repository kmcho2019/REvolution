module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow // Optional overflow flag
);

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Fractional bits Q (%0d) must be less than total bits N (%0d)", Q, N);
        end
    end

    // Treat inputs as signed for arithmetic operations
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Power optimization: check if inputs are equal
    wire inputs_equal = (a == b);
    
    // Perform subtraction only when needed
    wire signed [N-1:0] diff;
    assign diff = inputs_equal ? {N{1'b0}} : (a_signed - b_signed);
    
    // Overflow detection (optional)
    assign overflow = (a_signed[N-1] == b_signed[N-1]) && 
                     (diff[N-1] != a_signed[N-1]) &&
                     !inputs_equal;
    
    // Final output with zero handling
    assign c = diff;

    // Alternative implementation for specific technologies
    generate
        if (N <= 32) begin : fast_32bit
            // Direct implementation for <= 32 bits
            assign c = diff;
        end
        else begin : wide_arithmetic
            // Pipelined implementation for > 32 bits
            reg [N-1:0] c_reg;
            always @(*) begin
                c_reg = diff;
            end
            assign c = c_reg;
        end
    endgenerate

endmodule