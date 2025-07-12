module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;

    // Enable signals when each digit reaches 9
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = (counter[7:4] == 4'd9);
    assign ena[2] = (counter[11:8] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Ones digit (always increments)
            counter[3:0] <= (counter[3:0] == 4'd9) ? 4'd0 : counter[3:0] + 4'd1;

            // Tens digit (increments when ones rolls over)
            if (ena[0])
                counter[7:4] <= (counter[7:4] == 4'd9) ? 4'd0 : counter[7:4] + 4'd1;

            // Hundreds digit (increments when tens rolls over)
            if (ena[0] && ena[1])
                counter[11:8] <= (counter[11:8] == 4'd9) ? 4'd0 : counter[11:8] + 4'd1;

            // Thousands digit (increments when hundreds rolls over)
            if (ena[0] && ena[1] && ena[2])
                counter[15:12] <= (counter[15:12] == 4'd9) ? 4'd0 : counter[15:12] + 4'd1;
        end
    end

    assign q = counter;

endmodule