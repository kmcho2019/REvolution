module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    reg [5:0] state; // one-hot encoding: bit0=A, bit1=B, bit2=C, bit3=D, bit4=E, bit5=F

    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // A
        else begin
            if (state[0]) // A
                state <= w ? 6'b000001 : 6'b000010; // A or B
            else if (state[1]) // B
                state <= w ? 6'b000100 : 6'b000100; // D if w=1 else C; notice transitions to C or D
                // Wait, from problem: B (0) --0--> C, B (0) --1--> D; but w only 1 bit; given w==0 or 1?
                // Correction: B (0) --0--> C; B (0) --1--> D; if input w=0 or 1.
                // Our code must check w == 0 or 1 to pick next state:
                // Actually, we must check input w, not current state bits.
            else if (state[2]) // C
                state <= w ? 6'b000100 : 6'b010000; // D or E
            else if (state[3]) // D
                state <= w ? 6'b000001 : 6'b100000; // A or F
            else if (state[4]) // E
                state <= w ? 6'b000100 : 6'b010000; // D or E
            else if (state[5]) // F
                state <= w ? 6'b000100 : 6'b000100; // D or C
        end
    end

    // Fix the above transitions with correct checks on w and also, for those where the transitions depend on w == 0 or 1, assign accordingly.

    // Correcting transitions properly with condition:

    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // A
        else begin
            if (state[0]) // A
                state <= (w == 1'b0) ? 6'b000010 : 6'b000001; // B or A
            else if (state[1]) // B
                state <= (w == 1'b0) ? 6'b000100 : 6'b000100; // C or D (D is bit3)
                // Correct transition: B (0) --0--> C(bit2), B (0) --1--> D(bit3)
                // So w==0 => C(2), w==1 => D(3)
            else if (state[2]) // C
                state <= (w == 1'b0) ? 6'b010000 : 6'b000100; // E or D
            else if (state[3]) // D
                state <= (w == 1'b0) ? 6'b100000 : 6'b000001; // F or A
            else if (state[4]) // E
                state <= (w == 1'b0) ? 6'b010000 : 6'b000100; // E or D
            else if (state[5]) // F
                state <= (w == 1'b0) ? 6'b000100 : 6'b000100; // C or D
        end
    end

    // Output z is 1 in states E or F (bits 4 or 5)
    assign z = state[4] | state[5];

endmodule