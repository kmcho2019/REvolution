module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray-coded state encoding for minimal bit transitions
    parameter [1:0] A = 2'b00,  // Output 0
                   B = 2'b01,  // Output 0
                   D = 2'b11,  // Output 1 (changed position for Gray coding)
                   C = 2'b10;  // Output 0

    reg [1:0] state;

    // State transition logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;  // Async reset to state A
        end
        else begin
            case (state)
                A: state <= in ? B : A;  // A -> B if in=1 (00→01)
                B: state <= in ? B : C;  // B -> C if in=0 (01→10)
                C: state <= in ? D : A;  // C -> D if in=1 (10→11)
                D: state <= in ? B : C;  // D -> B if in=1 (11→01)
                default: state <= A;     // Handle undefined states
            endcase
        end
    end

    // Moore output depends only on current state
    assign out = (state == D);  // Output 1 only in state D (11)

endmodule