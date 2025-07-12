module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    wire [513:0] q_ext;

    // Zero pad q at boundaries: q_ext = {0, q, 0}
    assign q_ext = {1'b0, q, 1'b0};

    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // Extract neighbors from extended vector
            // left = q[i+1] (q_ext[i+2]), center = q[i] (q_ext[i+1]), right = q[i-1] (q_ext[i])
            // Rule 110 next state: (~left & center) | (center ^ right)
            next_q[i] = (~q_ext[i+2] & q_ext[i+1]) | (q_ext[i+1] ^ q_ext[i]);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule