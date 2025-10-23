module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding using localparams
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state and output logic
    always @(*) begin
        case (state)
            A: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
                out = 1'b0;
            end
            B: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
                out = 1'b0;
            end
            C: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
                out = 1'b0;
            end
            D: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

endmodule