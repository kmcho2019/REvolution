module TopModule(
    input clk, // Added clock signal
    input reset, // Added reset signal
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] y_next; // Next state of y
    assign Y1 = y[1]; // Directly assign Y1 to y[1]

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (
        (y == 3'b000 && ~w) || // A to B
        (y == 3'b001 && w) ||  // B to D
        (y == 3'b010 && w) ||  // C to D
        (y == 3'b011 && ~w) || // D to F
        (y == 3'b100 && w) ||  // E to D
        (y == 3'b101 && w)     // F to D
    ) ? 1'b1 : (
        (y == 3'b001 && ~w) || // B to C
        (y == 3'b010 && ~w) || // C to E
        (y == 3'b011 && w) ||  // D to A
        (y == 3'b100 && ~w) || // E to E
        (y == 3'b101 && ~w)    // F to C
    ) ? 1'b0 : 1'b0;

    // Sequential logic to update y[1] based on next_y1
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 3'b000; // Reset to state A
        end else begin
            y <= {y[2], next_y1, y[0]}; // Update y[1] based on next_y1
        end
    end

endmodule