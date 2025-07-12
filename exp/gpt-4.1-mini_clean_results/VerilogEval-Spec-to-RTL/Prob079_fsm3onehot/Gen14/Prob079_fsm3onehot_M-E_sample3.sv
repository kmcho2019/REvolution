module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);

    // Define symbolic parameters for one-hot states for clarity
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always @(*) begin
        casez ({state, in})
            {A, 1'b0}: next_state = A; // A, in=0 -> A
            {A, 1'b1}: next_state = B; // A, in=1 -> B
            {B, 1'b0}: next_state = C; // B, in=0 -> C
            {B, 1'b1}: next_state = B; // B, in=1 -> B
            {C, 1'b0}: next_state = A; // C, in=0 -> A
            {C, 1'b1}: next_state = D; // C, in=1 -> D
            {D, 1'b0}: next_state = C; // D, in=0 -> C
            {D, 1'b1}: next_state = B; // D, in=1 -> B
            default:   next_state = 4'b0000; // undefined states -> no next state
        endcase
    end

    assign out = state[3]; // output is 1 only in D state (MSB bit)

endmodule