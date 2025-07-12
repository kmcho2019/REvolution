module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding using parameters for readability
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg [1:0] state, next_state;

    // Sequential logic: state register with async positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic for next_state based on current state and input
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Combinational logic for Moore output depending only on current state
    always @(*) begin
        case (state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule