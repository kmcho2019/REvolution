module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Shift register states: [F E D C B A]
    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001;  // State A
        else begin
            case (1'b1)  // Find which bit is set
                state[0]: state <= w ? 6'b000001 : 6'b000010;  // A -> A or B
                state[1]: state <= w ? 6'b001000 : 6'b000100;  // B -> D or C
                state[2]: state <= w ? 6'b001000 : 6'b010000;  // C -> D or E
                state[3]: state <= w ? 6'b000001 : 6'b100000;  // D -> A or F
                state[4]: state <= w ? 6'b001000 : 6'b010000;  // E -> D or E
                state[5]: state <= w ? 6'b001000 : 6'b000100;  // F -> D or C
            endcase
        end
    end

    // Output is 1 when in state E or F (bits 4 or 5 set)
    assign z = state[4] | state[5];

endmodule