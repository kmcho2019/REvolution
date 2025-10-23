module right_shifter(
    input wire clk, // Explicitly define clk as a wire
    input wire d,   // Explicitly define d as a wire
    output reg [7:0] q = 8'b0 // Initialize q to 0
);

    // Always block triggered on the positive edge of the clock
    always @(posedge clk) begin
        // Non-blocking assignment to update q on the next clock cycle
        q <= {d, q[7:1]};
    end

endmodule