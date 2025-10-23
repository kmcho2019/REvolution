module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam A = 1'b0, B = 1'b1;
    reg state;
    reg areset_sync_0, areset_sync_1;

    // Synchronize asynchronous reset to clock domain
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            areset_sync_0 <= 1'b1;
            areset_sync_1 <= 1'b1;
        end else begin
            areset_sync_0 <= 1'b0;
            areset_sync_1 <= areset_sync_0;
        end
    end

    wire sync_reset = areset_sync_1;

    // Next state logic with Boolean expressions
    // From diagram:
    // B(1): next = in ? B(1) : A(0) --> next_state = in ? 1 : 0 = in
    // A(0): next = in ? A(0) : B(1) --> next_state = in ? 0 : 1 = ~in
    // So, next_state = (state & in) | (~state & ~in)
    wire next_state = (state & in) | (~state & ~in);

    // State register with synchronous reset (synchronized async reset)
    always @(posedge clk) begin
        if (sync_reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output is simply the state (Moore output)
    assign out = state;

endmodule