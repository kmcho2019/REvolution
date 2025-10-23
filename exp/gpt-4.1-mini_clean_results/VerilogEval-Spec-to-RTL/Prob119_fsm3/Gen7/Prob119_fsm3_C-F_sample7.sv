module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Parameterized state encoding for clarity and synthesis friendliness
    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    wire out_comb;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic with case statement for clarity and better synthesis
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output as combinational wire derived from current state only
    assign out_comb = (state == D) ? 1'b1 : 1'b0;
    assign out = out_comb;

endmodule