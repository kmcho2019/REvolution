module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= 3'b000; // A
        else case (state)
            3'b000: state <= w ? 3'b000 : 3'b001; // A -> A or B
            3'b001: state <= w ? 3'b010 : 3'b011; // B -> D or C
            3'b011: state <= w ? 3'b010 : 3'b110; // C -> D or E
            3'b010: state <= w ? 3'b000 : 3'b100; // D -> A or F
            3'b110: state <= w ? 3'b010 : 3'b110; // E -> D or E
            3'b100: state <= w ? 3'b010 : 3'b011; // F -> D or C
        endcase
    end

    assign z = state[2]; // E (110) or F (100)

endmodule