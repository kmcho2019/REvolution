module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract digits
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Internal registers for digits
    reg [3:0] ones_reg;
    reg [3:0] tens_reg;
    reg [3:0] hundreds_reg;
    reg [3:0] thousands_reg;

    always @(posedge clk) begin
        if (reset) begin
            ones_reg <= 4'd0;
            tens_reg <= 4'd0;
            hundreds_reg <= 4'd0;
            thousands_reg <= 4'd0;
            ena <= 3'b000;
        end else begin
            ena <= 3'b000;

            // Increment ones digit
            if (ones_reg == 4'd9) begin
                ones_reg <= 4'd0;
                ena[0] <= 1'b1;

                // Increment tens digit
                if (tens_reg == 4'd9) begin
                    tens_reg <= 4'd0;
                    ena[1] <= 1'b1;

                    // Increment hundreds digit
                    if (hundreds_reg == 4'd9) begin
                        hundreds_reg <= 4'd0;
                        ena[2] <= 1'b1;

                        // Increment thousands digit
                        if (thousands_reg == 4'd9) begin
                            thousands_reg <= 4'd0;
                        end else begin
                            thousands_reg <= thousands_reg + 1'b1;
                        end
                    end else begin
                        hundreds_reg <= hundreds_reg + 1'b1;
                    end
                end else begin
                    tens_reg <= tens_reg + 1'b1;
                end
            end else begin
                ones_reg <= ones_reg + 1'b1;
            end

            // Update output q
            q <= {thousands_reg, hundreds_reg, tens_reg, ones_reg};
        end
    end

endmodule