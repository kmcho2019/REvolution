module multi_8bit (
    input  wire        clk,      // Clock input for sequential operation
    input  wire        rst_n,    // Active-low synchronous reset
    input  wire        start,    // Start multiplication
    input  wire [7:0]  A,        // Multiplicand
    input  wire [7:0]  B,        // Multiplier
    output reg  [15:0] product,  // Product output
    output reg         done      // High when multiplication complete and product valid
);

    // Internal registers
    reg [15:0] accumulator;    // Accumulates partial sums
    reg [7:0]  multiplier;     // Holds multiplier during operation
    reg [3:0]  bit_index;      // Counts processed bits of multiplier
    reg        busy;           // Indicates multiplication in progress

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 16'b0;
            multiplier <= 8'b0;
            bit_index <= 4'd0;
            product <= 16'b0;
            done <= 1'b0;
            busy <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Initialize multiplication
                accumulator <= 16'b0;
                multiplier <= B;
                bit_index <= 4'd0;
                done <= 1'b0;
                busy <= 1'b1;
            end else if (busy) begin
                // Perform shift-and-add iteration
                if (multiplier[0]) begin
                    accumulator <= accumulator + (A << bit_index);
                end
                multiplier <= multiplier >> 1;
                bit_index <= bit_index + 1;

                if (bit_index == 4'd7) begin
                    // Last bit processed in next cycle
                    busy <= 1'b0;
                    done <= 1'b1;
                    product <= accumulator + (multiplier[0] ? (A << bit_index) : 16'b0); // Include last bit if set
                end
            end else begin
                done <= 1'b0; // Clear done until next start
            end
        end
    end

endmodule