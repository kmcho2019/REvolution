module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended version of q with boundary conditions (0)
    wire [513:0] q_ext = {1'b0, q, 1'b0};

    // Neighbor signals
    wire [511:0] left   = q_ext[513:2];  // q[i+1]
    wire [511:0] center = q_ext[512:1];  // q[i]
    wire [511:0] right  = q_ext[511:0];  // q[i-1]

    // Next state calculation using optimized Rule 110 logic
    wire [511:0] next_q = (center ^ right) | (~left & (center | right));

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule