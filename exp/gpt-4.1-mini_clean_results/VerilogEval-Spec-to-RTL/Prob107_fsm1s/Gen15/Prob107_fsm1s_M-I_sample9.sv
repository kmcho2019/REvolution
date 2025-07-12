module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding: B=0, A=1
    localparam B = 1'b0, A = 1'b1;
    reg state;

    // Next state logic as a single expression
    wire next_state = (state == B) ? (in ? B : A) : (in ? A : B);

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output directly driven by state
    assign out = (state == B);

endmodule