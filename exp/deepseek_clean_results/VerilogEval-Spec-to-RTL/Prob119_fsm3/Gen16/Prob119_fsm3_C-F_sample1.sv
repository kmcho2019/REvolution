module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding with explicit values and grouping
    // States with output=0 grouped together (A,B,C)
    // State with output=1 is separate (D)
    parameter [1:0] A = 2'b00,  // Output 0
                   B = 2'b01,  // Output 0
                   C = 2'b10,  // Output 0
                   D = 2'b11;  // Output 1

    reg [1:0] state;

    // State transition logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;  // Async reset to state A
        end
        else begin
            case (state)
                A: state <= in ? B : A;  // A -> B if in=1, else stay
                B: state <= in ? B : C;  // B -> C if in=0, else stay
                C: state <= in ? D : A;  // C -> D if in=1, else -> A
                D: state <= in ? B : C;  // D -> B if in=1, else -> C
                default: state <= A;     // Handle undefined states
            endcase
        end
    end

    // Moore output depends only on current state
    assign out = (state == D);  // Output 1 only in state D

endmodule