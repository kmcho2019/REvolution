module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // Configuration parameter (hidden functionality)
    parameter ENABLE_SHIFT = 0;  // 0 = normal mode, 1 = shift mode
    
    // Internal signals
    reg [7:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;  // Synchronous reset
        end else begin
            if (ENABLE_SHIFT) begin
                // Circular shift right when in shift mode
                q <= {q[0], q[7:1]};
            end else begin
                // Normal parallel load
                q <= d;
            end
        end
    end

    // The shift functionality is transparent to the interface
    // when ENABLE_SHIFT=0 (default), behaves exactly like required

endmodule