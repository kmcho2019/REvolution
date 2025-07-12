module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) state <= 0;  // State A = 0
        else case (state)
            0: state <= w ? 0 : 1;    // A -> A or B
            1: state <= w ? 2 : 3;    // B -> D or C
            3: state <= w ? 2 : 6;    // C -> D or E
            2: state <= w ? 0 : 4;    // D -> A or F
            6: state <= w ? 2 : 6;    // E -> D or E
            4: state <= w ? 2 : 3;    // F -> D or C
        endcase
    end

    assign z = (state == 6) | (state == 4);  // E or F states

endmodule