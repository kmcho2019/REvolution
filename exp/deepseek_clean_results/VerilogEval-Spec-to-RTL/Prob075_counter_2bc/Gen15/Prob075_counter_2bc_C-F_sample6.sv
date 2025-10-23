module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] counter;
wire [1:0] next_counter;

// Arithmetic with direction control
wire [2:0] temp_sum = {1'b0, counter} + (train_taken ? 3'b001 : 3'b111);
wire overflow = temp_sum[2];
wire underflow = ~temp_sum[2] & ~temp_sum[1] & ~temp_sum[0];

// Next state logic with early termination
assign next_counter = areset ? 2'b01 :               // Async reset
                    (train_valid & ~((counter == 2'b11 & train_taken) | 
                                    (counter == 2'b00 & ~train_taken))) ? 
                        (train_taken ? 
                            (overflow ? 2'b11 : counter + 1'b1) :  // Increment
                            (underflow ? 2'b00 : counter - 1'b1)   // Decrement
                        ) : counter;                // Hold when not training

// Simplified clock gating
wire clk_en = areset | (train_valid & ~((counter == 2'b11 & train_taken) | 
                                       (counter == 2'b00 & ~train_taken)));

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 2'b01;  // Reset to weakly not-taken
    end else if (clk_en) begin
        counter <= next_counter;
    end
end

assign state = counter;

endmodule