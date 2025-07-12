module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    integer i;
    reg [511:0] next_q;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors with zero boundary
            // Left: q[i+1] if i<511 else 0
            // Center: q[i]
            // Right: q[i-1] if i>0 else 0
            reg left, center, right;
            left = (i < 511) ? q[i+1] : 1'b0;
            center = q[i];
            right = (i > 0) ? q[i-1] : 1'b0;

            // Apply Rule 110 truth table
            // Next state = 1 for these triplets:
            // 110, 101, 011, 010, 001
            // Triplets where next state is 1: (left center right)
            // 1 1 0, 1 0 1, 0 1 1, 0 1 0, 0 0 1
            // We can encode next state logic as:
            // next = (left & center & ~right) ? 0
            // else if in above patterns => 1
            // Alternatively use the simplified rule formula:
            // next = (left & center & ~right) ? 0 : 
            //        (left & center & right) ? 0 :
            //        (left & ~center & right) ? 1 :
            //        (left & ~center & ~right) ? 0 :
            //        (~left & center & right) ? 1 :
            //        (~left & center & ~right) ? 1 :
            //        (~left & ~center & right) ? 1 :
            //        (~left & ~center & ~right) ? 0

            // This can be implemented more compactly as:
            // next = (left & center & ~right) ? 0 :
            //        (left & center & right) ? 0 :
            //        else 1 if center=0 or center=1 but not both neighbors 1

            // Another approach: use the formula for rule 110 from its bit pattern:
            // Rule110 in binary: 01101110 (from left to right for inputs 111..000)
            // index = {left, center, right} as 3-bit number:
            // index: 111=7 ... 000=0
            // bits = 0b01101110 = 0x6E = decimal 110
            // next state = rule110[index]
            // So we index into a constant 8-bit value with bits {left, center, right}

            reg [7:0] rule = 8'b01101110;
            integer idx;
            idx = {left, center, right};
            next_q[i] = rule[idx];
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end
endmodule