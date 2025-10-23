module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    integer i;

    // Combinational logic for Rule 110
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            assign next_q[i] = (left & center & ~right) |  // 110
                              (left & ~center & right) |   // 101
                              (~left & center) |          // 011, 010
                              (~left & ~center & right);  // 001
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule