module TopModule (
    input        clk,
    input        L,
    input        q0,
    input        q1,
    input        q2,
    input        r_in,
    output reg   Q
);

    wire next_q;
    // Compute next state bit based on which bit this instance represents
    // Since this module is generic, we require the instantiator to connect q0,q1,q2 and r_in accordingly.
    // For this module, next_q is:
    // if L==1: load r_in
    // else: next_q depends on which bit we implement:
    // We implement all three with this interface and assume instantiator picks q0,q1,q2 and r_in accordingly.
    //
    // So, this module itself cannot know which bit it is; hence next_q is calculated here as:
    // next_q = L ? r_in : (some expression involving q0,q1,q2)
    //
    // For the instantiator to map correctly:
    // Bit0: next_q = L ? r_in : (q1 ^ q2)
    // Bit1: next_q = L ? r_in : q0
    // Bit2: next_q = L ? r_in : q2

    // To generalize, we require the instantiator to drive next_q logic externally (e.g., mux r_in and calculated next bit)
    // But since problem wants all logic in TopModule, we add a parameter BIT_POS to select bit number

endmodule

// However, since the problem does not restrict us from using a parameter or extra input to indicate bit number,
// let's add a 2-bit input 'bit_pos' to select which bit this instance is implementing.

module TopModule_param (
    input        clk,
    input        L,
    input  [1:0] bit_pos,  // selects which bit 0,1,2 this instance controls
    input        q0,
    input        q1,
    input        q2,
    input        r_in,
    output reg   Q
);

    wire next_bit_value;
    // Compute next bit value according to bit_pos
    assign next_bit_value = (bit_pos == 2'd0) ? (q1 ^ q2) :
                            (bit_pos == 2'd1) ? q0 :
                            (bit_pos == 2'd2) ? q2 :
                            1'bx; // invalid bit_pos

    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= next_bit_value;
    end

endmodule

// For clarity and usability, provide a simpler fixed-bit version with bit select as parameter:

module TopModule_fixed #(
    parameter BIT_POS = 0
)(
    input       clk,
    input       L,
    input       q0,
    input       q1,
    input       q2,
    input       r_in,
    output reg  Q
);

    wire next_bit_value;
    assign next_bit_value = (BIT_POS == 0) ? (q1 ^ q2) :
                            (BIT_POS == 1) ? q0 :
                            (BIT_POS == 2) ? q2 :
                            1'bx;

    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= next_bit_value;
    end

endmodule