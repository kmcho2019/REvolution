module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    // Asynchronous reset signal (tied low here)
    wire async_reset_n = 1'b1;

    always @(posedge clk or negedge async_reset_n) begin
        if (!async_reset_n)
            q <= 1'b0;       // Reset output asynchronously if reset asserted
        else
            q <= d;          // Otherwise, sample d at rising clock edge
    end

endmodule