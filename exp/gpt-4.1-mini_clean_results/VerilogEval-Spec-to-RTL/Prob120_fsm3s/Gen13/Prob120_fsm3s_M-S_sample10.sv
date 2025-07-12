module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    // Next state and output logic
    always @(*) begin
        case (state)
            A: begin
                out = 1'b0;
                next_state = in ? B : A;
            end
            B: begin
                out = 1'b0;
                next_state = in ? B : C;
            end
            C: begin
                out = 1'b0;
                next_state = in ? D : A;
            end
            D: begin
                out = 1'b1;
                next_state = in ? B : C;
            end
            default: begin
                out = 1'b0;
                next_state = A;
            end
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule