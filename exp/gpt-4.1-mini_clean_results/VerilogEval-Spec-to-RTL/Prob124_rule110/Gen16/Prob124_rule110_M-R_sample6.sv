module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);

    reg [511:0] state;
    reg [511:0] next_state;

    // Combinational logic to compute next state according to Rule 110
    // Handle boundaries by zero-padding in a local vector
    always @* begin
        // Create extended vector with 0 at both boundaries
        reg [513:0] ext;
        integer i;
        ext[0] = 1'b0;          // right boundary zero (index 0)
        ext[513] = 1'b0;        // left boundary zero (index 513)
        ext[512:1] = state;

        for (i = 0; i < 512; i = i + 1) begin
            // Extract neighbors
            // Left neighbor: ext[i+2]
            // Center:       ext[i+1]
            // Right neighbor: ext[i]
            // Apply Rule 110: next = (~left & center) | (center ^ right)
            next_state[i] = (~ext[i+2] & ext[i+1]) | (ext[i+1] ^ ext[i]);
        end
    end

    // Sequential logic to update state
    always @(posedge clk) begin
        if (load)
            state <= data;
        else
            state <= next_state;
    end

    assign q = state;

endmodule