// Basic D Flip-Flop with Synchronous Reset
module SingleDFF (
    input clk,
    input reset,
    input d,
    output reg q
);

    always @(posedge clk) begin
        if (reset) q <= 1'b0;
        else q <= d;
    end

    // Optional scan chain implementation (commented out)
    // input scan_in;
    // input scan_en;
    // always @(posedge clk) begin
    //     if (reset) q <= 1'b0;
    //     else q <= scan_en ? scan_in : d;
    // end

endmodule

// Top Module with Distributed Reset Architecture
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Instantiate individual flip-flops
    SingleDFF dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));
    SingleDFF dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
    SingleDFF dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
    SingleDFF dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
    SingleDFF dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
    SingleDFF dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
    SingleDFF dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
    SingleDFF dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));

    // Optional scan chain connections (commented out)
    // wire [7:0] scan_in;
    // wire scan_en;
    // assign scan_in = {q[6:0], scan_in_primary};
    // assign scan_out = q[7];

endmodule