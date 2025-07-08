module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state of a cell based on Rule 110
    // Inputs: left, center, right
    // Returns: next center state
    function automatic logic rule110(input logic left, input logic center, input logic right);
        begin
            // According to the truth table, next state can be expressed as:
            // next = (left & center & ~right) ? 0 :
            //        (left & center & ~right) ? 1 :
            // but better to directly encode the rule in boolean expression:
            // Rule 110 decimal: 01101110 binary = 0b01101110 = 0x6E
            // Rule 110 is defined for 3 bits input LCR: 
            // Bit pattern in LCR order: 111 to 000 maps to 0 1 1 0 1 1 1 0
            // So next = bit(LCR, 7 - {left,center,right})
            // Let's implement with a case statement or directly by bits.
            logic [2:0] pattern;
            logic [7:0] rule = 8'b01101110;
            pattern = {left, center, right};
            rule110 = rule[7 - pattern];
        end
    endfunction

    integer i;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell
            for (i = 0; i < 512; i = i + 1) begin
                // left neighbor: q[i+1] if i < 511 else 0
                // right neighbor: q[i-1] if i > 0 else 0
                logic left = (i < 511) ? q[i+1] : 1'b0;
                logic center = q[i];
                logic right = (i > 0) ? q[i-1] : 1'b0;
                next_q[i] = rule110(left, center, right);
            end
            q <= next_q;
        end
    end

endmodule