module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding defined as local parameters for modularity and readability
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State transition logic using case statement for potentially better synthesis results
    always @(*) begin
        case (state)
            A: next_state = in? B : A;
            B: next_state = in? B : C;
            C: next_state = in? D : A;
            D: next_state = in? B : C;
            default: next_state = 4'bxxxx;
        endcase
    end

    // Output logic simplified for minimal switching activity and area usage
    assign out = state[3]; // Directly assigns '1' to out when state is D

endmodule