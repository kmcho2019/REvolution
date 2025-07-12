module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] next_q;

// Look-up table (LUT) for the next state
reg [3:0] lut [15:0];

// Initialize the LUT
initial begin
    for (int i = 0; i < 16; i++) begin
        if (i == 15) // Wrap around to 0 after 15
            lut[i] = 4'd0;
        else
            lut[i] = i + 1;
    end
end

always @(posedge clk)
    if (reset) // Synchronous reset
        q <= 4'd0;
    else
        q <= lut[q];

endmodule