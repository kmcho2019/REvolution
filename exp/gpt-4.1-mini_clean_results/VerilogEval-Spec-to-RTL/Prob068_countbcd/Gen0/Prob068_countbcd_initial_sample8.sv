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

    reg carry_ones, carry_tens, carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
            carry_ones <= 1'b0;
            carry_tens <= 1'b0;
            carry_hundreds <= 1'b0;
        end else begin
            // increment ones digit
            if (ones == 4'd9) begin
                q[3:0] <= 4'd0;
                carry_ones <= 1'b1;
            end else begin
                q[3:0] <= ones + 1;
                carry_ones <= 1'b0;
            end

            // increment tens digit if carry from ones
            if (carry_ones) begin
                if (tens == 4'd9) begin
                    q[7:4] <= 4'd0;
                    carry_tens <= 1'b1;
                end else begin
                    q[7:4] <= tens + 1;
                    carry_tens <= 1'b0;
                end
            end else begin
                carry_tens <= 1'b0;
            end

            // increment hundreds digit if carry from tens
            if (carry_tens) begin
                if (hundreds == 4'd9) begin
                    q[11:8] <= 4'd0;
                    carry_hundreds <= 1'b1;
                end else begin
                    q[11:8] <= hundreds + 1;
                    carry_hundreds <= 1'b0;
                end
            end else begin
                carry_hundreds <= 1'b0;
            end

            // increment thousands digit if carry from hundreds
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= thousands + 1;
                end
            end

            // ena signals indicate when to increment each digit except ones
            ena[0] <= carry_ones;       // enable tens digit
            ena[1] <= carry_tens;       // enable hundreds digit
            ena[2] <= carry_hundreds;   // enable thousands digit
        end
    end

endmodule