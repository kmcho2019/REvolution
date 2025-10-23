module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    reg [513:0] ext_q;       // zero-padded extended vector for boundaries
    reg [511:0] next_q;      // next state computed combinationally

    integer i;

    // Combinational block to compute next_q based on current q and zero boundaries
    always @(*) begin
        ext_q = {1'b0, q, 1'b0};   // zero padding at MSB+1 and LSB-1 positions
        for (i = 0; i < 512; i = i + 1) begin
            // Neighborhood bits
            // left neighbor = ext_q[i+2]
            // center cell   = ext_q[i+1]
            // right neighbor= ext_q[i]
            next_q[i] = (~ext_q[i+2] & ext_q[i+1]) | (ext_q[i+1] ^ ext_q[i]);
        end
    end

    // Sequential update: load new data or update q with next_q at posedge clk
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule