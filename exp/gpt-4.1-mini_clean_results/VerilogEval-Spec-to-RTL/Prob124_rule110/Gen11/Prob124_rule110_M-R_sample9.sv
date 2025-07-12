module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    reg [513:0] ext_state;      // zero-padded state for boundary conditions
    reg [511:0] next_state;

    integer i;

    // Combinational logic to compute next state from current q with zero padding
    always @* begin
        // Assign zero padding at boundaries
        ext_state[0]   = 1'b0;
        ext_state[513] = 1'b0;
        ext_state[512:1] = q;

        for (i = 0; i < 512; i = i + 1) begin
            // Left = ext_state[i+2]
            // Center = ext_state[i+1]
            // Right = ext_state[i]
            // Rule 110 logic: next = (~left & center) | (center ^ right);
            next_state[i] = (~ext_state[i+2] & ext_state[i+1]) | (ext_state[i+1] ^ ext_state[i]);
        end
    end

    // Sequential logic to update the register q with either loaded data or next_state
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule