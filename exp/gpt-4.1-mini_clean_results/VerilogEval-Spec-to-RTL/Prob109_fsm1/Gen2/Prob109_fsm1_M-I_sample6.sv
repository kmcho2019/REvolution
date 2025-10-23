module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Next state logic combined with state update
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

    // Moore output: directly assign output as wire to reduce logic and glitches
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule