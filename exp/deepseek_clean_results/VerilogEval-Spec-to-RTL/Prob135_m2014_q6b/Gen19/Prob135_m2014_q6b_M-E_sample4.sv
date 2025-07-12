module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Bitmask approach for next-state logic
    // Each 2-bit pair represents [w=0, w=1] behavior for y[1]
    // States ordered as A(000), B(001), C(010), D(011), E(100), F(101)
    wire [11:0] state_mask = 12'b00_00_00_10_11_11;
    
    // Select the appropriate bit based on current state and input
    wire next_y1 = state_mask[{y, w}];

endmodule