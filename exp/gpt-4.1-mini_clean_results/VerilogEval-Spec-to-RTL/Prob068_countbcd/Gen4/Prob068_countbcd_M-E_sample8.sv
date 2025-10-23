module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal wires to hold digits
    wire [3:0] digit0 = q[3:0];    // ones
    wire [3:0] digit1 = q[7:4];    // tens
    wire [3:0] digit2 = q[11:8];   // hundreds
    wire [3:0] digit3 = q[15:12];  // thousands

    reg [15:0] next_q;
    reg [2:0] next_ena;

    integer i;

    // Combinational logic to increment BCD stored in 16 bits
    always @(*) begin
        // Start incrementing from least significant digit
        next_q = q;
        next_ena = 3'b000;

        // Temporary digit holders for calculation
        reg [3:0] digits [3:0];
        for (i = 0; i < 4; i = i + 1) begin
            digits[i] = q[4*i +: 4];
        end

        // Increment ones digit by 1
        if (digits[0] == 9) begin
            digits[0] = 0;
            // Carry to tens
            if (digits[1] == 9) begin
                digits[1] = 0;
                next_ena[0] = 1; // enable for tens digit increment
                // Carry to hundreds
                if (digits[2] == 9) begin
                    digits[2] = 0;
                    next_ena[1] = 1; // enable for hundreds digit increment
                    // Carry to thousands
                    if (digits[3] == 9) begin
                        digits[3] = 0;
                        next_ena[2] = 1; // enable for thousands digit increment
                    end else begin
                        digits[3] = digits[3] + 1;
                        next_ena[2] = 1;
                    end
                end else begin
                    digits[2] = digits[2] + 1;
                    next_ena[1] = 1;
                end
            end else begin
                digits[1] = digits[1] + 1;
                next_ena[0] = 1;
            end
        end else begin
            digits[0] = digits[0] + 1;
        end

        // Assign back to next_q
        next_q = {digits[3], digits[2], digits[1], digits[0]};
    end

    // Sequential logic: synchronous reset and update
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            q <= next_q;
            ena <= next_ena;
        end
    end

endmodule