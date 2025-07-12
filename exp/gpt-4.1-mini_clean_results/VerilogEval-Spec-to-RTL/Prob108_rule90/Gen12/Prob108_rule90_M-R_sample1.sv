module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    reg [511:0] q_reg;
    wire [511:0] next_state;

    // Pad the current state with zero on both ends to represent boundaries
    wire [512:0] padded_left  = {1'b0, q_reg};
    wire [512:0] padded_right = {q_reg, 1'b0};

    // Next state: XOR of left neighbor and right neighbor for each bit
    assign next_state = padded_left[511:0] ^ padded_right[511:0];

    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_state;
    end

    assign q = q_reg;

endmodule