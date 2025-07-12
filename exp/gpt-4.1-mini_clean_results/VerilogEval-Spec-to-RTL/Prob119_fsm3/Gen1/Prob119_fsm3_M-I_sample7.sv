module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding using localparams
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] current_state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case (current_state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // default to safe state
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Moore output logic
    always @(*) begin
        case (current_state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule