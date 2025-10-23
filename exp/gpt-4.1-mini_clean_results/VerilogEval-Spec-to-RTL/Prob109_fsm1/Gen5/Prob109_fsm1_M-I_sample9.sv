module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Sequential logic: State update with asynchronous reset and inline next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else begin
            case (state)
                B: state <= (in == 1'b0) ? A : B;
                A: state <= (in == 1'b0) ? B : A;
                default: state <= B;
            endcase
        end
    end

    // Output directly reflects the current state
    assign out = state;

endmodule