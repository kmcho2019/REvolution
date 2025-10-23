module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    reg [513:0] ext_q;  // zero-padded q for neighbors

    integer i;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            ext_q = {1'b0, q, 1'b0};  // pad with zeros
            for (i = 0; i < 512; i = i + 1) begin
                // neighbors
                // left = ext_q[i+2], center = ext_q[i+1], right = ext_q[i]
                // next = (~left & center) | (center ^ right)
                q[i] <= (~ext_q[i+2] & ext_q[i+1]) | (ext_q[i+1] ^ ext_q[i]);
            end
        end
    end

endmodule