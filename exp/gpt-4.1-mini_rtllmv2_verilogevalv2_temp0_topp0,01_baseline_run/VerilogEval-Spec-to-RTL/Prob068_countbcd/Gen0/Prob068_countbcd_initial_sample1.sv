module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [2:0]  ena,
    output reg [15:0] q
);

    // Extract digits for clarity
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    reg [3:0] next_ones;
    reg [3:0] next_tens;
    reg [3:0] next_hundreds;
    reg [3:0] next_thousands;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                next_ones = 4'd0;
                ena[0] = 1'b1; // enable tens digit increment
            end else begin
                next_ones = ones + 1;
                ena[0] = 1'b0;
            end

            // Increment tens digit if enabled
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    next_tens = 4'd0;
                    ena[1] = 1'b1; // enable hundreds digit increment
                end else begin
                    next_tens = tens + 1;
                    ena[1] = 1'b0;
                end
            end else begin
                next_tens = tens;
                ena[1] = 1'b0;
            end

            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    next_hundreds = 4'd0;
                    ena[2] = 1'b1; // enable thousands digit increment
                end else begin
                    next_hundreds = hundreds + 1;
                    ena[2] = 1'b0;
                end
            end else begin
                next_hundreds = hundreds;
                ena[2] = 1'b0;
            end

            // Increment thousands digit if enabled
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    next_thousands = 4'd0;
                end else begin
                    next_thousands = thousands + 1;
                end
            end else begin
                next_thousands = thousands;
            end

            q <= {next_thousands, next_hundreds, next_tens, next_ones};
        end
    end

endmodule