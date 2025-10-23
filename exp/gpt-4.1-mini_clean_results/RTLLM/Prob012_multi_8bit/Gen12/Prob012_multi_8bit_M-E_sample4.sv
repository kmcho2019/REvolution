module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         done
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [3:0] bit_count;
    reg running;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product     <= 16'b0;
            done        <= 1'b0;
            multiplicand <= 8'b0;
            multiplier  <= 8'b0;
            accumulator <= 16'b0;
            bit_count   <= 4'd0;
            running     <= 1'b0;
        end else begin
            if (start && !running) begin
                // Initialize registers on start
                multiplicand <= A;
                multiplier   <= B;
                accumulator  <= 16'b0;
                bit_count    <= 4'd0;
                done         <= 1'b0;
                running      <= 1'b1;
            end else if (running) begin
                // If current LSB of multiplier is 1, add multiplicand to accumulator
                if (multiplier[0])
                    accumulator <= accumulator + {{8{1'b0}}, multiplicand};

                // Shift multiplicand left by 1
                multiplicand <= multiplicand << 1;

                // Shift multiplier right by 1
                multiplier <= multiplier >> 1;

                bit_count <= bit_count + 1;

                // Check if all bits processed
                if (bit_count == 7) begin
                    product <= accumulator;
                    done <= 1'b1;
                    running <= 1'b0;
                end
            end else begin
                done <= 1'b0; // Clear done when not running
            end
        end
    end

endmodule