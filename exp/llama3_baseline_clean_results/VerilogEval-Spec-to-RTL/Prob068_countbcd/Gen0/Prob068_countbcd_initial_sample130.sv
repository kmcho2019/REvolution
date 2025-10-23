module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Internal signals
    reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
    reg [2:0] ena_int;
    reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;

    assign ena = ena_int;
    assign q = {q_thousands, q_hundreds, q_tens, q_ones};

    // Next state logic
    always @(*) begin
        next_ones = q_ones;
        next_tens = q_tens;
        next_hundreds = q_hundreds;
        next_thousands = q_thousands;
        ena_int = 3'b000;

        if (q_ones == 4'd9) begin
            next_ones = 4'd0;
            ena_int[0] = 1'b1;
        end else begin
            next_ones = q_ones + 1'b1;
        end

        if (ena_int[0] && q_tens == 4'd9) begin
            next_tens = 4'd0;
            ena_int[1] = 1'b1;
        end else if (ena_int[0]) begin
            next_tens = q_tens + 1'b1;
        end else begin
            next_tens = q_tens;
        end

        if (ena_int[1] && q_hundreds == 4'd9) begin
            next_hundreds = 4'd0;
            ena_int[2] = 1'b1;
        end else if (ena_int[1]) begin
            next_hundreds = q_hundreds + 1'b1;
        end else begin
            next_hundreds = q_hundreds;
        end

        if (ena_int[2] && q_thousands == 4'd9) begin
            next_thousands = 4'd0;
        end else if (ena_int[2]) begin
            next_thousands = q_thousands + 1'b1;
        end else begin
            next_thousands = q_thousands;
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            q_ones <= 4'd0;
            q_tens <= 4'd0;
            q_hundreds <= 4'd0;
            q_thousands <= 4'd0;
        end else begin
            q_ones <= next_ones;
            q_tens <= next_tens;
            q_hundreds <= next_hundreds;
            q_thousands <= next_thousands;
        end
    end

endmodule