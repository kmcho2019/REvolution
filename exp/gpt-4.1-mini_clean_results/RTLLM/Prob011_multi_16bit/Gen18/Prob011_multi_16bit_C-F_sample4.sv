module multi_16bit (
    input          clk,
    input          rst_n,     // active low reset
    input          start,
    input  [15:0]  ain,       // multiplicand
    input  [15:0]  bin,       // multiplier
    output reg [31:0] yout,
    output reg     done
);

    reg [4:0] i;               // shift count 0..16
    reg [15:0] areg;           // multiplicand register (static)
    reg [15:0] breg;           // multiplier register (static)
    reg [31:0] product;        // accumulator

    // Shift count control and input loading
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
        end else if (start && i == 5'd0) begin
            // On start when idle, load inputs and reset count
            areg <= ain;
            breg <= bin;
            i <= 5'd1;           // start processing from bit 0 (count from 1 for convenience)
        end else if (i != 5'd0 && i < 5'd17) begin
            i <= i + 5'd1;
        end else if (!start) begin
            i <= 5'd0;           // reset count if start deasserted
        end
    end

    // Product accumulation and output register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else if (start && i == 5'd1) begin
            // Reset accumulator at first cycle after loading inputs
            product <= 32'd0;
            done <= 1'b0;
            yout <= 32'd0;
        end else if (i > 5'd1 && i < 5'd17) begin
            // For each bit position i-1 (0 to 15), check areg bit, add shifted multiplier if set
            if (areg[i-2]) begin
                product <= product + ( {16'd0, breg} << (i-2) );
            end else begin
                product <= product;
            end
            done <= 1'b0;
            yout <= 32'd0;
        end else if (i == 5'd17) begin
            // Multiplication complete
            yout <= product;
            done <= 1'b1;
        end else if (i == 5'd0) begin
            // Idle/reset output
            product <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end
    end

endmodule