module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output reg  [7:0]  q
);

    // Internal signal to hold next value for q
    reg [7:0] q_next;

    // Combinational logic for asynchronous reset
    // When reset is asserted, q_next is 0 immediately (asynchronously)
    // Else, q_next follows input d synchronously on clock
    always @(*) begin
        if (areset)
            q_next = 8'b0;
        else
            q_next = d;
    end

    // Register with asynchronous reset behavior by combining reset logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;   // Asynchronous reset active-high clears output immediately
        else
            q <= q_next; // On clock, update q with q_next (which tracks d if not reset)
    end

endmodule