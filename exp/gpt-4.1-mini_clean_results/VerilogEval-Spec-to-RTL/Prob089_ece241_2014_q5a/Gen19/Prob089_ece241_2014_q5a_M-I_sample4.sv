module TopModule (
    input  wire clk,
    input  wire areset,  // Asynchronous active-high reset input
    input  wire x,
    output wire z
);

    // Synchronize asynchronous reset into clk domain
    reg [1:0] reset_sync;
    always @(posedge clk or posedge areset) begin
        if (areset)
            reset_sync <= 2'b11;  // Assert reset synchronizer outputs when async reset asserted
        else
            reset_sync <= {reset_sync[0], 1'b0};
    end
    wire sync_reset = reset_sync[1];  // Synchronized reset (used as synchronous reset)

    // FSM state register (1 bit)
    // State encoding:
    // 0 = COPY bits (pass bits until first 1)
    // 1 = INVERT bits (invert remaining bits)
    reg state;

    // Next state combinational logic uses input x directly (no input registering)
    wire next_state = (state == 1'b0) ? (x ? 1'b1 : 1'b0) : 1'b1;

    // FSM state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset state asynchronously on async reset
        else
            state <= next_state;  // Update state synchronously after reset is released
    end

    // Moore output: z = x XOR state
    assign z = x ^ state;

endmodule