module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

// Next state logic for y[1]
wire y1_next;

assign y1_next = (
    // Current state is A (000), y[1] stays 0
    (y == 3'b000 && w == 1'b0)? 1'b0 :
    // Current state is A (000), y[1] stays 0
    (y == 3'b000 && w == 1'b1)? 1'b0 :
    // Current state is B (001), y[1] stays 0
    (y == 3'b001 && w == 1'b0)? 1'b0 :
    // Current state is B (001), y[1] becomes 1
    (y == 3'b001 && w == 1'b1)? 1'b1 :
    // Current state is C (010), y[1] stays 1
    (y == 3'b010 && w == 1'b0)? 1'b1 :
    // Current state is C (010), y[1] stays 1
    (y == 3'b010 && w == 1'b1)? 1'b1 :
    // Current state is D (011), y[1] stays 1
    (y == 3'b011 && w == 1'b0)? 1'b1 :
    // Current state is D (011), y[1] becomes 0
    (y == 3'b011 && w == 1'b1)? 1'b0 :
    // Current state is E (100), y[1] stays 0
    (y == 3'b100 && w == 1'b0)? 1'b0 :
    // Current state is E (100), y[1] becomes 1
    (y == 3'b100 && w == 1'b1)? 1'b1 :
    // Current state is F (101), y[1] stays 1
    (y == 3'b101 && w == 1'b0)? 1'b1 :
    // Current state is F (101), y[1] stays 1
    (y == 3'b101 && w == 1'b1)? 1'b1 : 1'b0
);

assign Y1 = y[1];

endmodule