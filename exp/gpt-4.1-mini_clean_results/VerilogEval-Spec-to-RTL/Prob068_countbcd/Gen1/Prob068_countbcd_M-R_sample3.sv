module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract digits for clarity
    wire [3:0] ones = q[3:0];
    wire [3:0] tens = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Combinational carry generation
    wire ones_carry = (ones == 4'd9);
    wire tens_carry = (tens == 4'd9);
    wire hundreds_carry = (hundreds == 4'd9);

    // Compute enables for upper digits based on carry chain
    wire ena_tens = ones_carry;
    wire ena_hundreds = ena_tens & tens_carry;
    wire ena_thousands = ena_hundreds & hundreds_carry;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Update ones digit
            if (ones_carry)
                q[3:0] <= 4'd0;
            else
                q[3:0] <= ones + 1'b1;

            // Update tens digit
            if (ena_tens) begin
                if (tens_carry)
                    q[7:4] <= 4'd0;
                else
                    q[7:4] <= tens + 1'b1;
            end

            // Update hundreds digit
            if (ena_hundreds) begin
                if (hundreds_carry)
                    q[11:8] <= 4'd0;
                else
                    q[11:8] <= hundreds + 1'b1;
            end

            // Update thousands digit
            if (ena_thousands) begin
                if (thousands == 4'd9)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= thousands + 1'b1;
            end

            // Output enable signals indicate when the corresponding digit increments
            ena <= {ena_thousands, ena_hundreds, ena_tens};
        end
    end

endmodule