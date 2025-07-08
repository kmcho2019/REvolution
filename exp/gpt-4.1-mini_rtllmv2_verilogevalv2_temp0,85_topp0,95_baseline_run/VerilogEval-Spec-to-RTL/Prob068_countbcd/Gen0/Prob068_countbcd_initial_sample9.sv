module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal digit wires for clarity
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Internal registers for digits
    reg [3:0] digit_0, digit_1, digit_2, digit_3;

    always @(posedge clk) begin
        if (reset) begin
            digit_0 <= 4'd0;
            digit_1 <= 4'd0;
            digit_2 <= 4'd0;
            digit_3 <= 4'd0;
            ena <= 3'b000;
        end else begin
            // Default ena to zero
            ena <= 3'b000;

            // Increment ones digit
            if (digit_0 == 4'd9) begin
                digit_0 <= 4'd0;
                // Enable incrementing tens digit
                ena[0] <= 1'b1;

                // Increment tens digit if enabled
                if (digit_1 == 4'd9) begin
                    digit_1 <= 4'd0;
                    ena[1] <= 1'b1;

                    if (digit_2 == 4'd9) begin
                        digit_2 <= 4'd0;
                        ena[2] <= 1'b1;

                        if (digit_3 == 4'd9) begin
                            digit_3 <= 4'd0;
                        end else begin
                            digit_3 <= digit_3 + 4'd1;
                        end

                    end else begin
                        digit_2 <= digit_2 + 4'd1;
                    end

                end else begin
                    digit_1 <= digit_1 + 4'd1;
                end

            end else begin
                digit_0 <= digit_0 + 4'd1;
            end
        end
    end

    // Pack digits into output q
    always @* begin
        q = {digit_3, digit_2, digit_1, digit_0};
    end

endmodule