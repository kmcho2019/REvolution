module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam [1:0] state_B = 2'b01;
    localparam [1:0] state_A = 2'b10;

    reg [1:0] state, next_state;

    // Next state combinational logic derived from FSM:
    // B->A if in==0; else B->B
    // A->B if in==0; else A->A
    always @(*) begin
        if (state == state_B) begin
            if (in == 1'b0)
                next_state = state_A;
            else
                next_state = state_B;
        end else if (state == state_A) begin
            if (in == 1'b0)
                next_state = state_B;
            else
                next_state = state_A;
        end else begin
            next_state = state_B; // default/reset fallback
        end
    end

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= state_B;
        else
            state <= next_state;
    end

    // Output is 1 when in state B, 0 when in state A
    // Directly use state_B encoding bit 0 as output
    assign out = state[0];

endmodule