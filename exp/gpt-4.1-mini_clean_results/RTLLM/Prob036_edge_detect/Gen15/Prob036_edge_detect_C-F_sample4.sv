module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output wire rise,   // Output pulse for rising edge
    output wire down    // Output pulse for falling edge
);

    // Register to hold previous value of 'a'
    reg a_prev;

    // Sequential logic: store previous 'a' on each clock edge
    // Reset to 0 asynchronously on rst_n deassert
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Combinational logic to detect rising edge: 0 -> 1 transition
    assign rise = (~a_prev) & a;

    // Combinational logic to detect falling edge: 1 -> 0 transition
    assign down = a_prev & (~a);

endmodule