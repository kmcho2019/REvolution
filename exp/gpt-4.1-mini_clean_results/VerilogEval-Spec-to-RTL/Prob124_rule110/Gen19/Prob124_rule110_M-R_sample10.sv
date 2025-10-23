module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    reg [511:0] state;

    // Zero-padded left neighbor vector: shifted right with zero inserted at MSB
    wire [511:0] left  = {state[510:0], 1'b0};
    // Center is current state
    wire [511:0] center = state;
    // Zero-padded right neighbor vector: shifted left with zero inserted at LSB
    wire [511:0] right = {1'b0, state[511:1]};

    // Rule 110 next state logic applied vector-wise:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            state <= next_state;
        end
    end

    assign q = state;

endmodule