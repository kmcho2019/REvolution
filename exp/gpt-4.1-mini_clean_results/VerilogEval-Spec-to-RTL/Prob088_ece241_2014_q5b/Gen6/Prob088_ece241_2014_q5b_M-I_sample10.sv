module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // Binary encoding for states
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = (state == A) ? (x ? B : A) : B;

    // Asynchronous active-high reset state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic (Mealy FSM): z = (state == A) ? x : ~x;
    assign z = (state == A) ? x : ~x;

endmodule