module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;

    // Pre-compute max conditions for all digits
    wire ones_max = (counter[3:0] == 4'd9);
    wire tens_max = (counter[7:4] == 4'd9);
    wire hundreds_max = (counter[11:8] == 4'd9);

    // Parallel enable generation (reduced logic depth)
    assign ena[0] = ones_max;
    assign ena[1] = ones_max & tens_max;
    assign ena[2] = ones_max & tens_max & hundreds_max;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Ones digit (always increments)
            counter[3:0] <= ones_max ? 4'd0 : counter[3:0] + 1'b1;

            // Tens digit (increments on ones rollover)
            if (ena[0]) begin
                counter[7:4] <= tens_max ? 4'd0 : counter[7:4] + 1'b1;
            end

            // Hundreds digit (increments on tens rollover)
            if (ena[1]) begin
                counter[11:8] <= hundreds_max ? 4'd0 : counter[11:8] + 1'b1;
            end

            // Thousands digit (increments on hundreds rollover)
            if (ena[2]) begin
                counter[15:12] <= (counter[15:12] == 4'd9) ? 4'd0 : counter[15:12] + 1'b1;
            end
        end
    end

endmodule