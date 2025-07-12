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

    // Using case statement within an always block for a more structured implementation
    always_comb begin
        case ({in, state})
            5'b00001: {next_state, out} = {A, 1'b0}; // in=0, state=A
            5'b10001: {next_state, out} = {B, 1'b0}; // in=1, state=A
            5'b00010: {next_state, out} = {C, 1'b0}; // in=0, state=B
            5'b10010: {next_state, out} = {B, 1'b0}; // in=1, state=B
            5'b00100: {next_state, out} = {A, 1'b0}; // in=0, state=C
            5'b10100: {next_state, out} = {D, 1'b0}; // in=1, state=C
            5'b10000: {next_state, out} = {C, 1'b1}; // in=0, state=D
            5'b10000: {next_state, out} = {B, 1'b1}; // in=1, state=D
            default: {next_state, out} = {4'bxxxx, 1'b0};
        endcase
    end

endmodule