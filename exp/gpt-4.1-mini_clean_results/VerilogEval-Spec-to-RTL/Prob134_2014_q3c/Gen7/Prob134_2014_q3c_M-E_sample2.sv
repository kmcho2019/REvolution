module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode present state y[2:0] into one-hot signals for clarity
    wire s0 = (y == 3'b000);
    wire s1 = (y == 3'b001);
    wire s2 = (y == 3'b010);
    wire s3 = (y == 3'b011);
    wire s4 = (y == 3'b100);

    // One-hot encoded next state bits
    reg n0, n1, n2, n3, n4;

    always @(*) begin
        // Default all next state bits to zero
        n0 = 1'b0; n1 = 1'b0; n2 = 1'b0; n3 = 1'b0; n4 = 1'b0;

        case ({x, y})
            // {x,y} = {x, y[2:0]}
            // For each present state y and input x, assign exactly one next state bit
            {1'b0, 3'b000}: n0 = 1'b1; // next state 000
            {1'b1, 3'b000}: n1 = 1'b1; // next state 001

            {1'b0, 3'b001}: n1 = 1'b1; // next state 001
            {1'b1, 3'b001}: n4 = 1'b1; // next state 100

            {1'b0, 3'b010}: n2 = 1'b1; // next state 010
            {1'b1, 3'b010}: n1 = 1'b1; // next state 001

            {1'b0, 3'b011}: n1 = 1'b1; // next state 001
            {1'b1, 3'b011}: n2 = 1'b1; // next state 010

            {1'b0, 3'b100}: n3 = 1'b1; // next state 011
            {1'b1, 3'b100}: n4 = 1'b1; // next state 100

            default: n0 = 1'b1; // default to 000 state next
        endcase
    end

    // Convert one-hot next state back to binary code [2:0]
    wire [2:0] next_state_bin =
        (n0 ? 3'b000 :
         n1 ? 3'b001 :
         n2 ? 3'b010 :
         n3 ? 3'b011 :
         n4 ? 3'b100 : 3'b000);

    // Output z is '1' for states 3'b011 and 3'b100, else '0'
    assign z = s3 | s4;

    // Y0 is the LSB of next_state_bin
    assign Y0 = next_state_bin[0];

endmodule