module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // Synchronize reset de-assertion to clk to reduce timing complexity
    reg reset_sync_0, reset_sync_1;
    wire reset_sync;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            reset_sync_0 <= 1'b1;
            reset_sync_1 <= 1'b1;
        end else begin
            reset_sync_0 <= 1'b0;
            reset_sync_1 <= reset_sync_0;
        end
    end

    assign reset_sync = reset_sync_1;

    reg state, next_state;

    // State register with asynchronous reset for spec compliance,
    // but reset release synchronized internally for better timing.
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else if (!reset_sync)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Next state logic: 
    // If in COPY (0) and input is 1, move to INVERT (1).
    // Otherwise, remain in current state.
    always @(*) begin
        if (state == 1'b0) begin
            if (x == 1'b1)
                next_state = 1'b1;
            else
                next_state = 1'b0;
        end else begin
            next_state = 1'b1;
        end
    end

    // Output is Moore output = x XOR state
    assign z = x ^ state;

endmodule