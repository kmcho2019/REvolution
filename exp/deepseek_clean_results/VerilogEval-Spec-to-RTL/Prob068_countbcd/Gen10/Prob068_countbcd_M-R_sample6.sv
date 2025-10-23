module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];

    // Combinational enable logic
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) & ena[0];
    assign ena[2] = (hundreds == 4'd9) & ena[1];

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Ones digit (always increments)
            if (ones == 4'd9) begin
                counter[3:0] <= 4'd0;
            end else begin
                counter[3:0] <= ones + 4'd1;
            end

            // Tens digit (increments when ones rolls over)
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    counter[7:4] <= 4'd0;
                end else begin
                    counter[7:4] <= tens + 4'd1;
                end
            end

            // Hundreds digit (increments when tens rolls over)
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    counter[11:8] <= 4'd0;
                end else begin
                    counter[11:8] <= hundreds + 4'd1;
                end
            end

            // Thousands digit (increments when hundreds rolls over)
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    counter[15:12] <= 4'd0;
                end else begin
                    counter[15:12] <= thousands + 4'd1;
                end
            end
        end
    end

    assign q = counter;

endmodule