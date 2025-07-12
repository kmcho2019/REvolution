// D Flip-Flop module with active high asynchronous reset
module DFF(
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset signal
    input           d,          // Input data
    output          q           // Output data
);

    reg q_reg = 1'b0; // Initialize with reset value

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 1'b0; // Reset condition
        end else begin
            q_reg <= d; // Clock edge condition
        end
    end

    assign q = q_reg;

endmodule

// TopModule with 8 D flip-flops
module TopModule(
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset signal
    input   [7:0]   d,          // Input data
    output  [7:0]   q           // Output data
);

    // Instantiate 8 DFF modules
    DFF dff0(.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
    DFF dff1(.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
    DFF dff2(.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
    DFF dff3(.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));
    DFF dff4(.clk(clk), .areset(areset), .d(d[4]), .q(q[4]));
    DFF dff5(.clk(clk), .areset(areset), .d(d[5]), .q(q[5]));
    DFF dff6(.clk(clk), .areset(areset), .d(d[6]), .q(q[6]));
    DFF dff7(.clk(clk), .areset(areset), .d(d[7]), .q(q[7]));

endmodule