module TopModule (
    input  [2:0] y,  // current state encoded as 3 bits: y2 y1 y0
    input        w,  // input w
    output       Y1  // output is current y[1]
);

    // Current state bits for convenience
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Compute next-state y[1] bit based on the FSM transitions:

    // Analyzing transitions:

    // States and next states:
    // A (000): w=0 -> B(001), y1_next=0; w=1 -> A(000), y1_next=0
    // B (001): w=0 -> C(010), y1_next=1; w=1 -> D(011), y1_next=1
    // C (010): w=0 -> E(100), y1_next=0; w=1 -> D(011), y1_next=1
    // D (011): w=0 -> F(101), y1_next=0; w=1 -> A(000), y1_next=0
    // E (100): w=0 -> E(100), y1_next=0; w=1 -> D(011), y1_next=1
    // F (101): w=0 -> C(010), y1_next=1; w=1 -> D(011), y1_next=1

    // From the above:
    // next y1=1 for:
    // - B (001), both w=0 and 1
    // - C (010), w=1
    // - E (100), w=1
    // - F (101), both w=0 and 1

    // Expressed as Boolean function for y1_next:

    wire in_B = (~y2) & (~y1) & ( y0); // 001
    wire in_C = (~y2) & ( y1) & (~y0); // 010
    wire in_E = ( y2) & (~y1) & (~y0); // 100
    wire in_F = ( y2) & (~y1) & ( y0); // 101

    // y1_next = 1 if:
    // - in_B (regardless w)
    // - in_C and w
    // - in_E and w
    // - in_F (regardless w)

    wire y1_next = (in_B) 
                   | (in_C & w) 
                   | (in_E & w) 
                   | (in_F);

    // Output Y1 is current state's y[1]
    assign Y1 = y1;

endmodule