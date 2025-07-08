module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    integer i;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell using Rule 110
            for (i = 0; i < 512; i = i + 1) begin
                // Neighbors with boundary zero assumption
                // Left = q[i+1], Center = q[i], Right = q[i-1]
                // For i=0, q[i-1]=0; for i=511, q[i+1]=0
                reg left, center, right;
                left   = (i < 511) ? q[i+1] : 1'b0;
                center = q[i];
                right  = (i > 0)   ? q[i-1] : 1'b0;

                // Compute next state using Rule 110 truth table:
                // next = 1 for patterns: 110,101,011,010,001
                // i.e. when (left,center,right) = 
                // (1,1,0), (1,0,1), (0,1,1), (0,1,0), (0,0,1)
                //
                // One expression from the rule:
                // next = (left & center & ~right) ? 1 : 0 is false
                // But better to write directly the sum of patterns where next=1:
                // next = (~left & center & right) | (~left & center & ~right) | (~left & ~center & right) | (left & ~center & right) | (left & center & ~right)
                // Simplify expression by checking Rule 110 standard boolean:
                // next = (left & center & ~right) | (left & ~center & right) | (~left & center) | (~left & ~center & right);
                //
                // Alternatively, from Wikipedia:
                // next = (left & center & ~right) | (left & ~center & right) | (~left & center) | (~left & ~center & right);

                next_q[i] = (left & center & ~right) | (left & ~center & right) | (~left & center) | (~left & ~center & right);
            end
            q <= next_q;
        end
    end

endmodule