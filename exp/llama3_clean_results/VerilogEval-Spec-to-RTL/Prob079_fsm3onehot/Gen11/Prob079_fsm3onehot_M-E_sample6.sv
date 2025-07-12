module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // LUT for state transition and output logic
    assign {next_state, out} = (
        (state == A && in == 1'b0)? {A, 1'b0} :
        (state == A && in == 1'b1)? {B, 1'b0} :
        (state == B && in == 1'b0)? {C, 1'b0} :
        (state == B && in == 1'b1)? {B, 1'b0} :
        (state == C && in == 1'b0)? {A, 1'b0} :
        (state == C && in == 1'b1)? {D, 1'b0} :
        (state == D && in == 1'b0)? {C, 1'b0} :
        (state == D && in == 1'b1)? {B, 1'b1} :
        {4'bxxxx, 1'b0}
    );

    // Alternatively, using a case statement within a procedural block (not recommended for combinational logic)
    // always @(*) begin
    //     case ({state, in})
    //         {A, 1'b0}: {next_state, out} = {A, 1'b0};
    //         {A, 1'b1}: {next_state, out} = {B, 1'b0};
    //         {B, 1'b0}: {next_state, out} = {C, 1'b0};
    //         {B, 1'b1}: {next_state, out} = {B, 1'b0};
    //         {C, 1'b0}: {next_state, out} = {A, 1'b0};
    //         {C, 1'b1}: {next_state, out} = {D, 1'b0};
    //         {D, 1'b0}: {next_state, out} = {C, 1'b0};
    //         {D, 1'b1}: {next_state, out} = {B, 1'b1};
    //         default: {next_state, out} = {4'bxxxx, 1'b0};
    //     endcase
    // end

endmodule