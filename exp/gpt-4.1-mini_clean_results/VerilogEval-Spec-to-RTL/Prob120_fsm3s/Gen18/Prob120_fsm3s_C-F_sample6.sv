module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // Binary encoded states
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic with case statement; input 'in' evaluated once per case
    always @(*) begin
        case (state)
            A: if (in == 1'b0) next_state = A; else next_state = B;
            B: if (in == 1'b0) next_state = C; else next_state = B;
            C: if (in == 1'b0) next_state = A; else next_state = D;
            D: if (in == 1'b0) next_state = C; else next_state = B;
            default: next_state = A; // Defensive default
        endcase
    end

    // Sequential logic with synchronous active high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output: 1 only in state D, simplified combinational assignment
    assign out = (state == D);

endmodule