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

    // Combinational next state logic using direct boolean operators
    assign next_state = (state == B) ? (~in ? A : B)
                                    : (~in ? B : A);

    // Asynchronous reset and state update on clk or areset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Reset state to B
        else
            state <= next_state;
    end

    // Moore output as continuous assignment: depends only on state
    assign out = (state == B);

endmodule