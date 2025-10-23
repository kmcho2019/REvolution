module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Create vectors representing left, center, right neighbors for all cells
    wire [511:0] left, center, right;
    
    assign center = q;
    // left: q shifted left by 1 with zero padding at LSB
    assign left = {q[510:0], 1'b0};
    // right: q shifted right by 1 with zero padding at MSB
    assign right = {1'b0, q[511:1]};
    
    // Apply Rule 110:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_q = (~left & center) | (center ^ right);
    
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule