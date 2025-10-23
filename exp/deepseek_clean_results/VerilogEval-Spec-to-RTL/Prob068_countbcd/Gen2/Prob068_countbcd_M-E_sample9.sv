module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] increment_mask;
    
    // Next value calculation
    wire [15:0] next_counter;
    assign next_counter = reset ? 16'd0 : 
        counter + 
        (increment_mask[0] ? 16'h0001 : 16'h0000) +
        (increment_mask[1] ? 16'h0010 : 16'h0000) +
        (increment_mask[2] ? 16'h0100 : 16'h0000) +
        16'h0001;  // Always increment ones digit
    
    // Digit overflow detection
    wire ones_overflow = (counter[3:0] == 4'd9);
    wire tens_overflow = (counter[7:4] == 4'd9);
    wire hundreds_overflow = (counter[11:8] == 4'd9);
    
    // Enable signals
    assign ena[0] = ones_overflow;
    assign ena[1] = ones_overflow && tens_overflow;
    assign ena[2] = ones_overflow && tens_overflow && hundreds_overflow;
    
    // Increment mask generation
    always @(*) begin
        increment_mask = 3'b000;
        if (ones_overflow) begin
            increment_mask[0] = 1'b1;
            if (tens_overflow) begin
                increment_mask[1] = 1'b1;
                if (hundreds_overflow) begin
                    increment_mask[2] = 1'b1;
                end
            end
        end
    end
    
    // Register update
    always @(posedge clk) begin
        counter <= next_counter;
    end
    
    assign q = counter;

endmodule