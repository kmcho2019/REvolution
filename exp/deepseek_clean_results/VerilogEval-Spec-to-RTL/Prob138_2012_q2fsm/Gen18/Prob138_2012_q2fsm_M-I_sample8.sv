module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding
    parameter [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101;

    reg [2:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= w ? B : A;
                B: state <= w ? C : D;
                C: state <= w ? E : D;
                D: state <= w ? F : A;
                E: state <= w ? E : D;
                F: state <= w ? C : D;
                default: state <= A;
            endcase
        end
    end

    // Output is high for states E (100) or F (101)
    assign z = state[2] & ~state[1];  // Matches states 4 and 5

endmodule