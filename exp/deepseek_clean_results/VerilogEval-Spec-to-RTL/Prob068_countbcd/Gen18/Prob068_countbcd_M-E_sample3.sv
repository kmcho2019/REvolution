module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [15:0] next_counter = counter + 16'd1;
    wire [3:0] ones_next = next_counter[3:0];
    wire [3:0] tens_next = next_counter[7:4];
    wire [3:0] hundreds_next = next_counter[11:8];
    wire [3:0] thousands_next = next_counter[15:12];

    // BCD correction logic
    wire ones_overflow = (ones_next > 4'd9);
    wire tens_overflow = (tens_next > 4'd9);
    wire hundreds_overflow = (hundreds_next > 4'd9);
    wire thousands_overflow = (thousands_next > 4'd9);

    // Enable signal generation
    assign ena[0] = (ones_next == 4'd0) & (counter[3:0] == 4'd9);
    assign ena[1] = (tens_next == 4'd0) & (counter[7:4] == 4'd9);
    assign ena[2] = (hundreds_next == 4'd0) & (counter[11:8] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Handle BCD rollover for each digit
            if (ones_overflow) begin
                counter[3:0] <= 4'd0;
                counter[7:4] <= counter[7:4] + 4'd1;
            end else begin
                counter[3:0] <= next_counter[3:0];
            end

            if (tens_overflow) begin
                counter[7:4] <= 4'd0;
                counter[11:8] <= counter[11:8] + 4'd1;
            end

            if (hundreds_overflow) begin
                counter[11:8] <= 4'd0;
                counter[15:12] <= counter[15:12] + 4'd1;
            end

            if (thousands_overflow) begin
                counter[15:12] <= 4'd0;
            end
        end
    end

    assign q = counter;

endmodule