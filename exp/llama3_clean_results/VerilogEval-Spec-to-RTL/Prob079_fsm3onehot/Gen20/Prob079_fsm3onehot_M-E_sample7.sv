module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always @(*) begin
        case ({in, state})
            // A, in = 0
            5'b00001: {next_state, out} = {A, 1'b0};
            // A, in = 1
            5'b10001: {next_state, out} = {B, 1'b0};
            // B, in = 0
            5'b00010: {next_state, out} = {C, 1'b0};
            // B, in = 1
            5'b10010: {next_state, out} = {B, 1'b0};
            // C, in = 0
            5'b00100: {next_state, out} = {A, 1'b0};
            // C, in = 1
            5'b10100: {next_state, out} = {D, 1'b0};
            // D, in = 0
            5'b10000: {next_state, out} = {C, 1'b1};
            // D, in = 1
            5'b10000: {next_state, out} = {B, 1'b1};
            default: {next_state, out} = {4'bxxxx, 1'bx};
        endcase
    end

endmodule