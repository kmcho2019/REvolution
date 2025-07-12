module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // Binary encoded states
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Next state and output logic (Moore FSM)
    always @(*) begin
        case (state)
            A: begin
                out = 1'b0;
                next_state = (in) ? B : A;
            end
            B: begin
                out = 1'b0;
                next_state = (in) ? B : C;
            end
            C: begin
                out = 1'b0;
                next_state = (in) ? D : A;
            end
            D: begin
                out = 1'b1;
                next_state = (in) ? B : C;
            end
            default: begin
                out = 1'b0;
                next_state = A;
            end
        endcase
    end

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule