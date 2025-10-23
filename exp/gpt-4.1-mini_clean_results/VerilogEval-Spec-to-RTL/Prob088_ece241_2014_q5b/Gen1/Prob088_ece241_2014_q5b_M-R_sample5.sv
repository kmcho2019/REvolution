module TopModule (
    input  clk,
    input  areset,
    input  x,
    output     z
);

    // One-hot state encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state;

    // Next state combinational signals
    wire [1:0] next_state;

    // Asynchronous active-high reset state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using assign and ternary operators
    assign next_state = (state == A) ? (x ? B : A) : B;

    // Output logic (Mealy): output depends on current state and input
    assign z = (state == A) ? x : (~x);

endmodule