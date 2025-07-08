module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal signals for carry between digits
    wire carry_ones, carry_tens, carry_hundreds;

    // Extract digits for readability
    wire [3:0] ones    = q[3:0];
    wire [3:0] tens    = q[7:4];
    wire [3:0] hundreds= q[11:8];
    wire [3:0] thousands = q[15:12];

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'd0;
        end else begin
            // Initialize enables to 0
            ena <= 3'd0;

            // Increment ones digit
            if (ones == 4'd9) begin
                // ones rolls over to 0 and carry is generated
                q[3:0] <= 4'd0;
                ena[0] <= 1'b1; // enable tens increment
            end else begin
                q[3:0] <= ones + 1;
            end

            // Increment tens digit if enabled
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    q[7:4] <= 4'd0;
                    ena[1] <= 1'b1; // enable hundreds increment
                end else begin
                    q[7:4] <= tens + 1;
                end
            end

            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    q[11:8] <= 4'd0;
                    ena[2] <= 1'b1; // enable thousands increment
                end else begin
                    q[11:8] <= hundreds + 1;
                end
            end

            // Increment thousands digit if enabled
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    // roll over thousands to 0
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= thousands + 1;
                end
            end
        end
    end

endmodule