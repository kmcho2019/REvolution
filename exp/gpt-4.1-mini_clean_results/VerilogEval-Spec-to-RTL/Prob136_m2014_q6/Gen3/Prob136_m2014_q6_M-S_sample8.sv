module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic: combined w and state for simpler case
    always @(*) begin
        case ({state, w})
            {A,1'b0}: next_state = B;
            {A,1'b1}: next_state = A;
            {B,1'b0}: next_state = C;
            {B,1'b1}: next_state = D;
            {C,1'b0}: next_state = E;
            {C,1'b1}: next_state = D;
            {D,1'b0}: next_state = F;
            {D,1'b1}: next_state = A;
            {E,1'b0}: next_state = E;
            {E,1'b1}: next_state = D;
            {F,1'b0}: next_state = C;
            {F,1'b1}: next_state = D;
            default:  next_state = A;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 if state E or F, else 0
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule