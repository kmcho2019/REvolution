module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state bit based on left, center, right bits using Rule 110
    function rule110_bit;
        input left, center, right;
        begin
            // According to the rule table:
            // next = (~left & center) | (center ^ right) & (~(left & center & right))
            // However, simpler to just implement exact given:
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0

            // So next = ( (left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right) ) 

            // Actually, from table:
            // next = ((left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right))
            // But the table shows that (0,1,1), (0,1,0), (0,0,1), (1,1,0), (1,0,1) all yield 1.

            // Another way: Use a 3-bit vector to index a 8-bit vector representing next state:
            // bit pattern: left center right
            // index = {left, center, right}
            // next_state = 8'b01101110 (bit 7 = pattern 111)
            // From table: pattern -> next_state (bit index)
            // 111 (7) -> 0
            // 110 (6) -> 1
            // 101 (5) -> 1
            // 100 (4) -> 0
            // 011 (3) -> 1
            // 010 (2) -> 1
            // 001 (1) -> 1
            // 000 (0) -> 0
            rule110_bit = 8'b01101110[{left, center, right}];
        end
    endfunction

    reg [511:0] next_q;

    integer i;
    always @(*) begin
        for (i=0; i<512; i=i+1) begin
            // Determine neighbors with boundary conditions zero
            // left: q[i+1], center: q[i], right: q[i-1]
            // if i=511, left neighbor is 0
            // if i=0, right neighbor is 0
            reg left, center, right;
            center = q[i];
            left = (i == 511) ? 1'b0 : q[i+1];
            right = (i == 0) ? 1'b0 : q[i-1];
            next_q[i] = rule110_bit(left, center, right);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule