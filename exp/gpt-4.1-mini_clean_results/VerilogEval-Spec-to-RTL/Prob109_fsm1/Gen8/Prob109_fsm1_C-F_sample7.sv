module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: A = 0, B = 1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic: simpler conditional logic
    assign next_state = (state == B && in == 1'b0) ? A :
                        (state == A && in == 1'b0) ? B : state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Reset to state B
        else
            state <= next_state;
    end

    // Moore output logic: output depends only on current state
    assign out = (state == B);

endmodule