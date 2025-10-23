module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    // State register
    reg state;

    // Next state logic (combinational)
    wire next_state;
    assign next_state = (state == STATE_A) ? (in ? STATE_A : STATE_B) :
                                        (in ? STATE_B : STATE_A);

    // State register (sequential with async reset)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;  // Reset to state B
        end
        else begin
            state <= next_state;
        end
    end

    // Output is simply the state value (B=1, A=0)
    assign out = state;

endmodule