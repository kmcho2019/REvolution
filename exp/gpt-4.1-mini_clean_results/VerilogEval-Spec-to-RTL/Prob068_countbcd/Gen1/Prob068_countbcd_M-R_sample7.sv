module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    wire [3:0] ones = q[3:0];
    wire [3:0] tens = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Combinational logic to determine carries (increment enables)
    wire carry_ones = (ones == 4'd9);
    wire carry_tens = (tens == 4'd9) & carry_ones;
    wire carry_hundreds = (hundreds == 4'd9) & carry_tens;

    // ena indicates when to increment the upper digits: tens, hundreds, thousands
    // According to problem, ena[0] for tens, ena[1] for hundreds, ena[2] for thousands
    always @(*) begin
        ena[0] = carry_ones;
        ena[1] = carry_tens;
        ena[2] = carry_hundreds;
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // Increment ones digit
            if (carry_ones)
                q[3:0] <= 4'd0;
            else
                q[3:0] <= ones + 1;

            // Increment tens digit if carry from ones
            if (carry_ones) begin
                if (carry_tens)
                    q[7:4] <= 4'd0;
                else
                    q[7:4] <= tens + 1;
            end else begin
                q[7:4] <= tens;
            end

            // Increment hundreds digit if carry from tens
            if (carry_tens) begin
                if (carry_hundreds)
                    q[11:8] <= 4'd0;
                else
                    q[11:8] <= hundreds + 1;
            end else begin
                q[11:8] <= hundreds;
            end

            // Increment thousands digit if carry from hundreds
            if (carry_hundreds) begin
                if (thousands == 4'd9)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= thousands + 1;
            end else begin
                q[15:12] <= thousands;
            end
        end
    end

endmodule