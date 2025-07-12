module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Combinational wires for neighbors with zero padding
    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_q;

    // Construct left_shifted = q shifted left by 1 bit with 0 at LSB boundary
    assign left_shifted = {q[510:0], 1'b0};

    // Construct right_shifted = q shifted right by 1 bit with 0 at MSB boundary
    assign right_shifted = {1'b0, q[511:1]};

    // Compute next_q according to Rule 110 for all 512 bits
    // next_q[i] = (~left & center) | (center ^ right)
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110_logic_512
            assign next_q[i] = (~left_shifted[i] & q[i]) | (q[i] ^ right_shifted[i]);
        end
    endgenerate

    // Sequential logic: on clock edge, load or update q
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule