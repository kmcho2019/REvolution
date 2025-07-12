module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset - clear all bits
            q <= 8'b0;
        end else begin
            // Parallel load implementation using shift-register concept
            // Each bit position maintains its value independently
            q[0] <= d[0];
            q[1] <= d[1];
            q[2] <= d[2];
            q[3] <= d[3];
            q[4] <= d[4];
            q[5] <= d[5];
            q[6] <= d[6];
            q[7] <= d[7];
        end
    end

    // Alternative implementation using concatenation for more compact code
    /*
    always @(posedge clk) begin
        q <= reset ? 8'b0 : d;
    end
    */

endmodule