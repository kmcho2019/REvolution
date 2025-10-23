module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding (one-hot)
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // Next state combinational logic based on one-hot encoding
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // safe default
        endcase
    end

    // Asynchronous reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;  // initialize to state B
        else
            state <= next_state;
    end

    // Moore output is 1 only in state B
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule