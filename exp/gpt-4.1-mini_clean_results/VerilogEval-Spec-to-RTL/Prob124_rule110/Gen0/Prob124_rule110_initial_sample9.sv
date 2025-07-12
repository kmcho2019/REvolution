module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state according to Rule 110
            // For each bit i:
            // left = q[i+1] if i<511 else 0
            // center = q[i]
            // right = q[i-1] if i>0 else 0
            // Use the rule table encoded in combinational logic:

            // rule_110 = (~(left & center & right)) & (left | center | right) & (~(left & ~center & ~right))
            // But better to simply implement the table via bits:
            // next = (left & center & right) ? 0 :
            //        (left & center & ~right) ? 1 :
            //        (left & ~center & right) ? 1 :
            //        (left & ~center & ~right) ? 0 :
            //        (~left & center & right) ? 1 :
            //        (~left & center & ~right) ? 1 :
            //        (~left & ~center & right) ? 1 :
            //        (~left & ~center & ~right) ? 0 : 0;

            // Alternatively, encode all possibilities as a 3-bit input to a truth table:
            // Index = {left, center, right}
            // Rule 110 in binary is 01101110 (bit 7 for 111, bit 0 for 000)
            // So next = rule_110[{left, center, right}]

            integer i;
            reg [7:0] rule = 8'b01101110;
            reg [511:0] next_q;

            for (i = 0; i < 512; i = i + 1) begin
                // get neighbors with boundary conditions
                reg left, center, right;
                left = (i < 511) ? q[i+1] : 1'b0;
                center = q[i];
                right = (i > 0) ? q[i-1] : 1'b0;
                next_q[i] = rule[{left, center, right}];
            end
            q <= next_q;
        end
    end

endmodule