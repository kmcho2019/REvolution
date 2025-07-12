module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] ena_next;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];

    // Shared adder logic
    wire [3:0] next_ones = (ones == 4'd9) ? 4'd0 : (ones + 4'd1);
    wire [3:0] next_tens = (tens == 4'd9) ? 4'd0 : (tens + 4'd1);
    wire [3:0] next_hundreds = (hundreds == 4'd9) ? 4'd0 : (hundreds + 4'd1);
    wire [3:0] next_thousands = (thousands == 4'd9) ? 4'd0 : (thousands + 4'd1);

    // Pipeline stage 1: Generate next counter values and enable conditions
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9) & ones_rollover;
    wire hundreds_rollover = (hundreds == 4'd9) & tens_rollover;

    // Pipeline stage 2: Register enable signals
    always @(posedge clk) begin
        if (reset) begin
            ena <= 3'b0;
        end else begin
            ena <= {hundreds_rollover, tens_rollover, ones_rollover};
        end
    end

    // Main counter logic with conditional updates
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Always update ones digit
            counter[3:0] <= next_ones;
            
            // Conditionally update other digits
            if (ena[0]) counter[7:4] <= next_tens;
            if (ena[1]) counter[11:8] <= next_hundreds;
            if (ena[2]) counter[15:12] <= next_thousands;
        end
    end

    assign q = counter;

endmodule