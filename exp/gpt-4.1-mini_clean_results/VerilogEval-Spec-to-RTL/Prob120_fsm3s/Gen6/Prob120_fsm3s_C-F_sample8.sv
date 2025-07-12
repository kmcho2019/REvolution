module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding as parameters
    localparam [1:0] A = 2'b00;
    localparam [1:0] B = 2'b01;
    localparam [1:0] C = 2'b10;
    localparam [1:0] D = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // Combinational next state logic using an always_comb with case statement
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic: output is 1 only in state D
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule