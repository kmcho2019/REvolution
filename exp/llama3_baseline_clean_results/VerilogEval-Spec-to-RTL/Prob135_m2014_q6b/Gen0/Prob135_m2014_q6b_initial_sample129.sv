module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Current state y
    // Next state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b001 && w) || (y == 3'b001) || 
                     (y == 3'b100 && w) || 
                     (y == 3'b101 && ~w) || 
                     (y == 3'b110) || 
                     (y == 3'b111 && w);

    // Output Y1 is the current value of y[1]
    assign Y1 = y[1];

    // For simulation purposes, to see the next state
    // reg [2:0] next_y;
    // always @(posedge clk) begin
    //     y <= next_y;
    // end
    // assign next_y[1] = next_y1;

endmodule