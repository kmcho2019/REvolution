module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // Internal synchronous reset signal (active high for first clock cycle)
    reg reset_sync = 1'b1;

    // Intermediate signals for next state options
    wire [3:0] shift_next = {q[2:0], data};
    wire [3:0] count_next = q + 4'b1111;  // Decrement q by 1 modulo 16

    // Next state mux with explicit priority: shift_ena > count_ena > hold
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

    // Sequential logic with synchronous reset and enable
    // Enable update only if reset is active or shifting or counting
    wire ena = reset_sync | shift_ena | count_ena;

    always @(posedge clk) begin
        if (reset_sync)
            reset_sync <= 1'b0;  // Clear reset after first clock
        if (ena)
            q <= next_q;
    end

endmodule