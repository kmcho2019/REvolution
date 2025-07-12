module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;
    wire [1:0] next_counter;

    // Arithmetic logic with direction control
    wire do_increment = train_valid & train_taken;
    wire do_decrement = train_valid & ~train_taken;
    wire direction = do_increment;
    
    // Shared adder/subtractor with saturation
    wire [2:0] extended_counter = {1'b0, counter};
    wire [2:0] temp_next = direction ? (extended_counter + 1) : (extended_counter - 1);
    
    // Saturation detection (overflow/underflow)
    wire overflow = temp_next[2];
    wire underflow = ~temp_next[2] & (temp_next[1:0] == 2'b11); // Underflow when borrow occurs
    
    // Next counter value
    assign next_counter = areset ? 2'b01 :               // Reset condition
                        (do_increment & ~overflow) ? temp_next[1:0] :  // Increment if no overflow
                        (do_decrement & ~underflow) ? temp_next[1:0] :  // Decrement if no underflow
                        counter;                         // Hold otherwise

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else begin
            counter <= next_counter;
        end
    end

    assign state = counter;

endmodule