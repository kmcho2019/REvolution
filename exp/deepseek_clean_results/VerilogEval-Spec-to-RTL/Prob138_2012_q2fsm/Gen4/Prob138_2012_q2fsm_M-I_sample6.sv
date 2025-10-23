module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding
    reg [2:0] state;
    parameter A = 3'b000,
             B = 3'b001,
             C = 3'b011,
             D = 3'b010,
             E = 3'b110,
             F = 3'b111;

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else case (state)
            A: state <= w ? B : A;
            B: state <= w ? C : D;
            C: state <= w ? E : D;
            D: state <= w ? F : A;
            E: state <= w ? E : D;
            F: state <= w ? C : D;
            default: state <= A;
        endcase
    end

    assign z = (state == E) | (state == F);  // Output when in E or F states

endmodule