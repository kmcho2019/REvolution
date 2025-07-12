module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);
    // State encoding using localparam instead of enum
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case(state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

    // State register with asynchronous active high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic combinational block
    always @(*) begin
        case(state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule