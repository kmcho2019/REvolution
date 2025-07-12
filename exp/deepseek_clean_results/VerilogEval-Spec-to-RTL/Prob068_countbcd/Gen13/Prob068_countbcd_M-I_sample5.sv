module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;
    reg en_tens, en_hundreds, en_thousands;
    wire ones_clock_en = ~reset; // Clock gating for ones digit

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b0;
        end else begin
            // Update all digits in parallel
            q[3:0] <= next_ones;
            q[7:4] <= next_tens;
            q[11:8] <= next_hundreds;
            q[15:12] <= next_thousands;
            
            // Register enable outputs
            ena[0] <= (q[3:0] == 4'd9);
            ena[1] <= (q[3:0] == 4'd9) && (q[7:4] == 4'd9);
            ena[2] <= (q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9);
        end
    end

    // Next state logic for all digits
    always @* begin
        // Ones digit (always increments)
        if (q[3:0] == 4'd9)
            next_ones = 4'd0;
        else
            next_ones = q[3:0] + 4'd1;

        // Tens digit (increments only when ones rolls over)
        if (ena[0]) begin
            if (q[7:4] == 4'd9)
                next_tens = 4'd0;
            else
                next_tens = q[7:4] + 4'd1;
        end else begin
            next_tens = q[7:4];
        end

        // Hundreds digit (increments only when tens rolls over)
        if (ena[1]) begin
            if (q[11:8] == 4'd9)
                next_hundreds = 4'd0;
            else
                next_hundreds = q[11:8] + 4'd1;
        end else begin
            next_hundreds = q[11:8];
        end

        // Thousands digit (increments only when hundreds rolls over)
        if (ena[2]) begin
            if (q[15:12] == 4'd9)
                next_thousands = 4'd0;
            else
                next_thousands = q[15:12] + 4'd1;
        end else begin
            next_thousands = q[15:12];
        end
    end

endmodule