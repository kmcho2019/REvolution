module TopModule(
    input  [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

// Define a structure to hold scancode and corresponding output values
typedef struct {
    logic [15:0] scancode;
    logic left;
    logic down;
    logic right;
    logic up;
} scancode_map_t;

// Define the array of structures to hold scancode mappings
scancode_map_t scancode_map[] = {
    {16'he06b, 1'b1, 1'b0, 1'b0, 1'b0},
    {16'he072, 1'b0, 1'b1, 1'b0, 1'b0},
    {16'he074, 1'b0, 1'b0, 1'b1, 1'b0},
    {16'he075, 1'b0, 1'b0, 1'b0, 1'b1}
};

// Initialize output signals to default values
initial begin
    left = 1'b0;
    down = 1'b0;
    right = 1'b0;
    up = 1'b0;
end

// Iterate through the scancode map array and assign output values
always @(*) begin
    foreach (scancode_map[i]) begin
        if (scancode == scancode_map[i].scancode) begin
            left = scancode_map[i].left;
            down = scancode_map[i].down;
            right = scancode_map[i].right;
            up = scancode_map[i].up;
        end else if (i == $size(scancode_map) - 1) begin
            // If no match is found, set output signals to default values
            left = 1'b0;
            down = 1'b0;
            right = 1'b0;
            up = 1'b0;
        end
    end
end

endmodule