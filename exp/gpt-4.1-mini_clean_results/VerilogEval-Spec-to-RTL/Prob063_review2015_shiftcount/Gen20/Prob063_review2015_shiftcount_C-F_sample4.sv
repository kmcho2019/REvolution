module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    // Synchronous internal reset signal asserted at startup, de-asserted after first clock
    reg reset_sync = 1'b1;

    // Compute next state for shift operation (shift left, MSB first)
    wire [3:0] shift_next = {q[2:0], data};

    // Compute next state for count operation (decrement modulo 16 using addition with 4'b1111)
    wire [3:0] count_next = q + 4'b1111;

    // Next state mux with explicit priority: reset > shift_ena > count_ena > hold
    reg [3:0] next_q;
    always @* begin
        if (reset_sync)
            next_q = 4'b0000;
        else if (shift_ena)
            next_q = shift_next;
        else if (count_ena)
            next_q = count_next;
        else
            next_q = q;
    end

    // Enable register update when shifting or counting active or during reset
    wire ena = reset_sync | shift_ena | count_ena;

    // Sequential logic: synchronous reset deassertion and register update on clock edge
    always @(posedge clk) begin
        if (reset_sync)
            reset_sync <= 1'b0;  // Deassert reset after first clock
        if (ena)
            q <= next_q;
    end

endmodule