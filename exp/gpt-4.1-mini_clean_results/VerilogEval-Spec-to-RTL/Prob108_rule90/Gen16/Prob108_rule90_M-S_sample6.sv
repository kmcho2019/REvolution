module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] next_q;

    // Compute next state: XOR of left and right neighbors, boundaries assumed zero
    assign next_q = (q << 1) ^ (q >> 1);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end
endmodule