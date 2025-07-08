module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal wires for digits
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Registers to hold next digit values and enable signals
    reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;
    reg [2:0] next_ena;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
            ena <= 3'b0;
        end else begin
            // Update q and ena with next computed values
            q <= {next_thousands, next_hundreds, next_tens, next_ones};
            ena <= next_ena;
        end
    end

    always @* begin
        // Default values: keep digits same and disable all enables
        next_ones = ones;
        next_tens = tens;
        next_hundreds = hundreds;
        next_thousands = thousands;
        next_ena = 3'b0;

        // Increment ones digit
        if (ones == 4'd9) begin
            next_ones = 4'd0;
            // Enable tens digit increment
            next_ena[0] = 1'b1;

            // Handle tens digit increment
            if (tens == 4'd9) begin
                next_tens = 4'd0;
                // Enable hundreds digit increment
                next_ena[1] = 1'b1;

                // Handle hundreds digit increment
                if (hundreds == 4'd9) begin
                    next_hundreds = 4'd0;
                    // Enable thousands digit increment
                    next_ena[2] = 1'b1;

                    // Handle thousands digit increment
                    if (thousands == 4'd9) begin
                        next_thousands = 4'd0; // roll over after 9999
                    end else begin
                        next_thousands = thousands + 1'b1;
                    end

                end else begin
                    next_hundreds = hundreds + 1'b1;
                end

            end else begin
                next_tens = tens + 1'b1;
            end

        end else begin
            next_ones = ones + 1'b1;
        end
    end

endmodule