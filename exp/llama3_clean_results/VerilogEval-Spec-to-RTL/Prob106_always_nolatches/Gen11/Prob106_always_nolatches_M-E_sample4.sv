module TopModule(
    input [15:0] scancode,
    output reg [3:0] arrow_keys
);

// Define the lookup table as a parameterized array
parameter [3:0] lut[65536] = {
    16'he06b: 4'b0001, // left
    16'he072: 4'b0010, // down
    16'he074: 4'b0100, // right
    16'he075: 4'b1000, // up
    default: 4'b0000  // default value for other scancodes
};

// Use the scancode as an index to access the corresponding output value
always @(*) begin
    arrow_keys = lut[scancode];
end

// Assign the output signals
assign left = arrow_keys[0];
assign down = arrow_keys[1];
assign right = arrow_keys[2];
assign up = arrow_keys[3];

endmodule