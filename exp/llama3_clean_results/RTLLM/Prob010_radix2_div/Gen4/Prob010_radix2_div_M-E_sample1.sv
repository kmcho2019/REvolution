module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

// Internal signals
reg [7:0] normalized_dividend;
reg [7:0] normalized_divisor;
reg [7:0] quotient;
reg [7:0] remainder;
reg [2:0] counter;
reg start_division;
reg result_valid;
reg [1:0] state;

// Define the states
localparam IDLE = 2'b00;
localparam NORMALIZE = 2'b01;
localparam DIVIDE = 2'b10;
localparam OUTPUT = 2'b11;

// Input stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        start_division <= 0;
        result_valid <= 0;
        res_valid <= 0;
    end else if (state == IDLE) begin
        if (opn_valid && !res_valid) begin
            // Save the inputs dividend and divisor
            if (sign) begin
                // Signed division
                normalized_dividend <= ({dividend[7]? {8{1'b1}} : {8{1'b0}}} + dividend);
                normalized_divisor <= ({divisor[7]? {8{1'b1}} : {8{1'b0}}} + divisor);
            end else begin
                // Unsigned division
                normalized_dividend <= dividend;
                normalized_divisor <= divisor;
            end
            counter <= 0;
            start_division <= 1;
            state <= NORMALIZE;
        end
    end
end

// Normalization stage
always @(posedge clk) begin
    if (state == NORMALIZE) begin
        // Normalize the dividend and divisor
        normalized_dividend <= normalized_dividend << 1;
        normalized_divisor <= normalized_divisor << 1;
        counter <= counter + 1;
        if (counter == 7) begin
            state <= DIVIDE;
        end
    end
end

// Division stage
always @(posedge clk) begin
    if (state == DIVIDE) begin
        // Perform the radix-2 division
        reg [8:0] subtraction;
        subtraction = {1'b0, normalized_dividend} - normalized_divisor;
        if (subtraction[8]) begin
            // No borrow
            normalized_dividend <= normalized_dividend << 1;
        end else begin
            // Borrow
            normalized_dividend <= {1'b1, normalized_dividend} + (normalized_divisor << 1);
        end
        counter <= counter + 1;
        if (counter == 7) begin
            state <= OUTPUT;
        end
    end
end

// Output stage
always @(posedge clk) begin
    if (state == OUTPUT) begin
        // Calculate the quotient and remainder
        quotient <= normalized_dividend[7:0];
        remainder <= normalized_dividend[15:8];
        result_valid <= 1;
        res_valid <= 1;
        state <= IDLE;
    end
end

// Assign the result
assign result = {remainder, quotient};

endmodule