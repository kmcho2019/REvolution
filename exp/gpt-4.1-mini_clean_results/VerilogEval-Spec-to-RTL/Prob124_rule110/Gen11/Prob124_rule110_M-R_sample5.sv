module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extend q with zeros at both ends to handle boundaries
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    // Extract neighbors as vectors by slicing the extended vector
    wire [511:0] left   = ext_q[513:2]; // bits shifted right by 1 (left neighbors)
    wire [511:0] center = ext_q[512:1]; // current bits
    wire [511:0] right  = ext_q[511:0]; // bits shifted left by 1 (right neighbors)

    // Apply Rule 110: next = (~left & center) | (center ^ right)
    wire [511:0] next_q = ((~left) & center) | (center ^ right);

    // Sequential update of the state q
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule