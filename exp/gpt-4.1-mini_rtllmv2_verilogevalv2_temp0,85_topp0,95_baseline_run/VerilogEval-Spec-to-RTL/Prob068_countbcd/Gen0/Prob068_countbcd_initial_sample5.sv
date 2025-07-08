module TopModule(
    input        clk,
    input        reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract digits
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Default ena signals to zero
            ena <= 3'b000;

            // Increment ones digit
            if (ones == 4'd9) begin
                // Ones digit rolls over to 0
                q[3:0] <= 4'd0;

                // Enable tens digit increment
                ena[0] <= 1'b1;
                if (tens == 4'd9) begin
                    q[7:4] <= 4'd0;

                    // Enable hundreds digit increment
                    ena[1] <= 1'b1;
                    if (hundreds == 4'd9) begin
                        q[11:8] <= 4'd0;

                        // Enable thousands digit increment
                        ena[2] <= 1'b1;
                        if (thousands == 4'd9) begin
                            // Roll over thousands digit to 0
                            q[15:12] <= 4'd0;
                        end else begin
                            q[15:12] <= thousands + 4'd1;
                        end
                    end else begin
                        q[11:8] <= hundreds + 4'd1;
                    end
                end else begin
                    q[7:4] <= tens + 4'd1;
                end
            end else begin
                q[3:0] <= ones + 4'd1;
            end
        end
    end

endmodule