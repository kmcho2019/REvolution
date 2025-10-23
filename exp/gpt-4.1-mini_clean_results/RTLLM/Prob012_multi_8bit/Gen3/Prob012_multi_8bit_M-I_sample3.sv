module multi_8bit (
    input           clk,
    input           rst_n,
    input      [7:0] A,
    input      [7:0] B,
    input           start,         // Start signal to begin multiplication
    output reg [15:0] product,
    output reg      ready          // Signal that product is ready
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [3:0] count;               // up to 8 cycles needed
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 8'd0;
            multiplier <= 8'd0;
            accumulator <= 16'd0;
            count <= 4'd0;
            product <= 16'd0;
            ready <= 1'b0;
            busy <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs and initialize
                multiplicand <= A;
                multiplier <= B;
                accumulator <= 16'd0;
                count <= 4'd0;
                ready <= 1'b0;
                busy <= 1'b1;
            end else if (busy) begin
                // Shift-and-add steps
                if (multiplier[0] == 1'b1)
                    accumulator <= accumulator + {8'd0, multiplicand};
                else
                    accumulator <= accumulator;

                // Shift multiplicand left by 1 for next bit (implicitly done by next iteration accumulator)
                multiplicand <= multiplicand << 1;

                // Shift multiplier right by 1 to process next bit
                multiplier <= multiplier >> 1;

                count <= count + 1;

                if (count == 7) begin
                    // All bits processed
                    product <= accumulator;
                    ready <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                ready <= 1'b0;  // ready only high for 1 cycle
            end
        end
    end

endmodule