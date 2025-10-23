module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    // Shift register bits: shiftreg[9:0]
    // Only one D flip-flop is used to store shiftreg[0]
    // Other bits are combinationally derived as next bits shifted right

    reg shiftreg_0; // single D flip-flop bit storing LSB of the shift register

    wire [9:1] shiftreg;  // combinational bits representing upper bits of the shift register

    reg [9:0] load_pattern;

    // Generate load pattern - encode 'data' into a one-hot shift register load pattern
    // We create a pattern with a single '1' at position 'data', counting down shift cycles

    // Since data can be zero, define load pattern: if data=0 -> load_pattern = 0 (timer expired)
    // else load_pattern = 1 << (data - 1)

    always @(*) begin
        if (data == 10'd0) 
            load_pattern = 10'b0;
        else
            load_pattern = 10'b1 << (data - 1);
    end

    // Shift register combinational bits assignment
    assign shiftreg[9] = load ? load_pattern[9] : shiftreg[8];
    assign shiftreg[8] = load ? load_pattern[8] : shiftreg[7];
    assign shiftreg[7] = load ? load_pattern[7] : shiftreg[6];
    assign shiftreg[6] = load ? load_pattern[6] : shiftreg[5];
    assign shiftreg[5] = load ? load_pattern[5] : shiftreg[4];
    assign shiftreg[4] = load ? load_pattern[4] : shiftreg[3];
    assign shiftreg[3] = load ? load_pattern[3] : shiftreg[2];
    assign shiftreg[2] = load ? load_pattern[2] : shiftreg[1];
    assign shiftreg[1] = load ? load_pattern[1] : shiftreg_0;

    // Next bit for the flip-flop: either loaded from load pattern or shiftreg[0] shifted right (which is zero)
    wire shiftreg_0_next = load ? load_pattern[0] : 1'b0; 

    always @(posedge clk) begin
        shiftreg_0 <= shiftreg_0_next;
    end

    // Terminal count is when entire 10-bit shift register == 0
    assign tc = ~(shiftreg_0 | shiftreg[1] | shiftreg[2] | shiftreg[3] | shiftreg[4] | shiftreg[5] | shiftreg[6] | shiftreg[7] | shiftreg[8] | shiftreg[9]);

endmodule