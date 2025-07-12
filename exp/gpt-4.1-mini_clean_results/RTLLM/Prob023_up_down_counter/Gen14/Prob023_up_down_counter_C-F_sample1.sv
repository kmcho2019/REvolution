module up_down_counter (
    input wire clk,          // Clock signal
    input wire reset,        // Synchronous reset signal (active high)
    input wire up_down,      // Direction control: 1 for up, 0 for down
    output reg [15:0] count  // 16-bit counter output
);

    reg [15:0] next_count;

    // Combinational logic: determine next counter value based on up_down
    always @(*) begin
        // Default assignment to prevent latches
        next_count = count;
        if (up_down)
            next_count = count + 16'd1;
        else
            next_count = count - 16'd1;
    end

    // Sequential logic: update count on rising clock edge or reset to zero
    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= next_count;
    end

endmodule