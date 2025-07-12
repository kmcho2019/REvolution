module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Load has priority - when asserted, take input data
    assign next_counter = load ? data : 
                         // Otherwise decrement if not zero
                         (|counter) ? (counter - 1'b1) : 10'b0;

    // Register update
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count is simply zero detection
    assign tc = ~(|counter);

endmodule