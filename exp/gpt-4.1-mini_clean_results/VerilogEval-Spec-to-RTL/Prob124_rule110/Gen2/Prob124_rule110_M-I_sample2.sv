module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Wires for neighbors with boundary zero padding
    wire [511:0] left;
    wire [511:0] right;
    wire [511:0] center;

    assign center = q;

    // left[i] = q[i+1], for i=0..510; left[511]=0 (boundary)
    assign left = {q[510:0], 1'b0};
    // right[i] = q[i-1], for i=1..511; right[0]=0 (boundary)
    assign right = {1'b0, q[511:1]};

    // next state combinational logic applying Rule 110 per bit:
    // next_q[i] = (~left[i] & center[i]) | (center[i] ^ right[i])
    wire [511:0] next_q = ((~left) & center) | (center ^ right);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule