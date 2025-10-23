module TopModule (
    input          clk,
    input          load,
    input  [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;

    // Boundary zeros handled by concatenation during shifts:
    // Left shift q by 1 with zero padded at LSB
    // Right shift q by 1 with zero padded at MSB
    // next_state = (q shifted left by 1) XOR (q shifted right by 1)
    assign next_state = ({q[510:0], 1'b0}) ^ ({1'b0, q[511:1]});

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule