module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding (inverted compared to example)
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Reset to state B
        else begin
            case(state)
                B: state <= (in == 1'b0) ? A : B;
                A: state <= (in == 1'b0) ? B : A;
                default: state <= B;
            endcase
        end
    end

    // Moore output depends on current state: out=1 if state is A, else 0
    assign out = (state == A) ? 1'b1 : 1'b0;

endmodule