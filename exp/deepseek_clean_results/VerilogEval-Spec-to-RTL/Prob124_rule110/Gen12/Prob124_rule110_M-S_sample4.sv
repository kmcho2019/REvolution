module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Handle boundary conditions (q[-1] and q[512] are 0)
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            // Direct implementation of Rule 110 truth table
            assign next_q[i] = (left & center & right) ? 1'b0 :
                              (left & center & ~right) ? 1'b1 :
                              (left & ~center & right) ? 1'b1 :
                              (left & ~center & ~right) ? 1'b0 :
                              (~left & center & right) ? 1'b1 :
                              (~left & center & ~right) ? 1'b1 :
                              (~left & ~center & right) ? 1'b1 :
                              1'b0;  // ~left & ~center & ~right
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule