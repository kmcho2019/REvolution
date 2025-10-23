module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // State definitions
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // Output logic (Moore machine)
    assign out = (state == D);

    // Next state logic
    always @(*) begin
        case (state) // synthesis parallel_case full_case
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

endmodule