module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    reg [511:0] state;

    // Output is registered state
    assign q = state;

    // Extended vector with zero padding to simplify neighbor extraction
    wire [513:0] ext_state = {1'b0, state, 1'b0};

    reg [511:0] next_state;

    integer i;
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Extract neighbors from the extended vector
            // left = ext_state[i+2], center = ext_state[i+1], right = ext_state[i]
            next_state[i] = (~ext_state[i+2] & ext_state[i+1]) | (ext_state[i+1] ^ ext_state[i]);
        end
    end

    // Sequential logic for loading or state update
    always @(posedge clk) begin
        if (load)
            state <= data;
        else
            state <= next_state;
    end

endmodule