module pe (
    input  wire        clk,
    input  wire        rst,    // asynchronous active-high reset
    input  wire signed [31:0] a,
    input  wire signed [31:0] b,
    output reg  signed [31:0] c
);

    // Intermediate signals
    wire signed [63:0] product;
    reg signed [32:0]  sum_ext; // 33 bits to detect overflow

    // Compute signed 32x32 multiplication (64-bit product)
    assign product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'sd0;
        end else begin
            // Extend accumulator to 33 bits for overflow detection
            sum_ext = {c[31], c} + product[31:0]; // add lower 32 bits product to accumulator

            // Check for overflow (if sign bit changed unexpectedly)
            // For saturation: if sum_ext > 2^31 -1 => saturate positive max
            //                 if sum_ext < -2^31  => saturate negative min
            if (sum_ext[32] != sum_ext[31]) begin
                // Overflow occurred
                if (sum_ext[32] == 0) begin
                    // Positive overflow, saturate to max positive 32-bit int
                    c <= 32'sh7FFF_FFFF;
                end else begin
                    // Negative overflow, saturate to min negative 32-bit int
                    c <= 32'sh8000_0000;
                end
            end else begin
                // No overflow, assign the lower 32 bits of sum_ext
                c <= sum_ext[31:0];
            end
        end
    end

endmodule