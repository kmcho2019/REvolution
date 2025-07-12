module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Internal signals for next state
    reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;
    wire ones_rollover, tens_rollover, hundreds_rollover;

    // Combinational logic for next state and enables
    always @(*) begin
        // Default assignments
        next_ones = q[3:0];
        next_tens = q[7:4];
        next_hundreds = q[11:8];
        next_thousands = q[15:12];
        ena = 3'b0;

        // Ones digit logic (always increments)
        if (q[3:0] == 4'd9) begin
            next_ones = 4'd0;
            ena[0] = 1'b1;
        end else begin
            next_ones = q[3:0] + 4'd1;
        end

        // Tens digit logic
        if (ena[0] && q[7:4] == 4'd9) begin
            next_tens = 4'd0;
            ena[1] = 1'b1;
        end else if (ena[0]) begin
            next_tens = q[7:4] + 4'd1;
        end

        // Hundreds digit logic
        if (ena[1] && q[11:8] == 4'd9) begin
            next_hundreds = 4'd0;
            ena[2] = 1'b1;
        end else if (ena[1]) begin
            next_hundreds = q[11:8] + 4'd1;
        end

        // Thousands digit logic
        if (ena[2] && q[15:12] == 4'd9) begin
            next_thousands = 4'd0;
        end else if (ena[2]) begin
            next_thousands = q[15:12] + 4'd1;
        end
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b0;
        end else begin
            q <= {next_thousands, next_hundreds, next_tens, next_ones};
            // ena is already set by combinational logic
        end
    end

endmodule