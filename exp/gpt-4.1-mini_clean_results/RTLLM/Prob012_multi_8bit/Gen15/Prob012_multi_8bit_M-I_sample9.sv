module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,    // Active low synchronous reset
    input  wire        start,    // Start signal to begin multiplication
    input  wire [7:0]  A,        // Multiplicand
    input  wire [7:0]  B,        // Multiplier
    output reg  [15:0] product,  // Product output
    output reg         ready     // Output valid flag
);

    // Internal registers
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [3:0] bit_count;  // Counts 8 bits

    // State machine: idle, busy
    reg busy;

    always @(posedge clk) begin
        if (!rst_n) begin
            product      <= 16'b0;
            ready        <= 1'b0;
            multiplicand <= 8'b0;
            multiplier   <= 8'b0;
            accumulator  <= 16'b0;
            bit_count    <= 4'b0;
            busy         <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Start multiplication
                multiplicand <= A;
                multiplier   <= B;
                accumulator  <= 16'b0;
                bit_count    <= 4'd0;
                busy         <= 1'b1;
                ready        <= 1'b0;
            end else if (busy) begin
                // Check LSB of multiplier; if set, add multiplicand shifted by bit_count to accumulator
                if (multiplier[0])
                    accumulator <= accumulator + (multiplicand << bit_count);
                // Shift multiplier right for next bit
                multiplier <= multiplier >> 1;

                bit_count <= bit_count + 1;

                if (bit_count == 4'd7) begin
                    // Last bit processed, multiplication done
                    product <= accumulator + ((multiplier[0]) ? (multiplicand << bit_count) : 16'b0);
                    ready   <= 1'b1;
                    busy    <= 1'b0;
                end
            end else begin
                // Not busy, output remains stable
                ready <= ready;
                product <= product;
            end
        end
    end

endmodule