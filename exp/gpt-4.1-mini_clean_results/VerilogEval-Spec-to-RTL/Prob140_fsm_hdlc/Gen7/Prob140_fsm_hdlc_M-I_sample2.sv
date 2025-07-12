module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Count consecutive ones: 3-bit register to hold 0..7 (7 means error state)
    reg [2:0] count_ones;
    reg in_d; // registered input to generate outputs based on previous input

    always @(posedge clk) begin
        if (reset) begin
            count_ones <= 3'd0;
            in_d       <= 1'b0;
            disc       <= 1'b0;
            flag       <= 1'b0;
            err        <= 1'b0;
        end else begin
            // Update count of consecutive ones
            if (in) begin
                if (count_ones < 3'd7)
                    count_ones <= count_ones + 3'd1;
                else
                    count_ones <= 3'd7; // stay in error state if already 7 or more
            end else begin
                count_ones <= 3'd0;
            end

            // Register input for output generation next cycle
            in_d <= in;

            // Generate outputs based on previous cycle's count and input
            // Because outputs must be asserted exactly one cycle after detection

            // disc = 1 cycle after detecting zero input following 5 ones
            disc <= (count_ones == 3'd5) && (in == 1'b0);

            // flag = 1 cycle after detecting zero input following 6 ones
            flag <= (count_ones == 3'd6) && (in == 1'b0);

            // err = asserted whenever count_ones is 7 (7 or more consecutive ones)
            err <= (count_ones == 3'd7);
        end
    end

endmodule