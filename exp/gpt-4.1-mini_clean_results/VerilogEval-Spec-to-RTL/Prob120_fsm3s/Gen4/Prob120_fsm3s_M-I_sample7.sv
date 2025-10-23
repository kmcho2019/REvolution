module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding - assign output as MSB of state D = 2'b11, so MSB=1 means output=1
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output directly from MSB of state (only D=2'b11 has MSB=1)
    assign out = state[1];

endmodule