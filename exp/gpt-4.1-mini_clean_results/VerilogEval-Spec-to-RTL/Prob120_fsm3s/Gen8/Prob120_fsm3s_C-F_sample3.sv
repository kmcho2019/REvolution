module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding using localparam for clarity and tool compatibility
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next-state logic using a clear case statement
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Defensive default
        endcase
    end

    // Sequential logic for state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic as combinational continuous assignment for simplicity
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule