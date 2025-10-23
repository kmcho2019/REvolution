module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] consecutive_ones;

    always @(posedge clk) begin
        if (reset) begin
            consecutive_ones <= 3'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            // Update consecutive ones counter
            if (in) begin
                if (consecutive_ones < 3'b111)
                    consecutive_ones <= consecutive_ones + 1;
            end else begin
                consecutive_ones <= 3'b0;
            end

            // Generate outputs (assert for one cycle after detection)
            disc <= (consecutive_ones == 3'b101) && !in;  // 5 ones followed by 0
            flag <= (consecutive_ones == 3'b110) && !in;  // 6 ones followed by 0
            err <= (consecutive_ones == 3'b111);         // 7 or more ones
        end
    end

endmodule