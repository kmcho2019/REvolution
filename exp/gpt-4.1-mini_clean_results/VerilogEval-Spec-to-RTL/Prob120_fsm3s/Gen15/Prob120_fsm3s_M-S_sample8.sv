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

    reg [1:0] state;

    // Next-state and output logic combined
    always @(*) begin
        out = 1'b0;
        case (state)
            A: begin
                out = 1'b0;
                if (in) state = B;
                else    state = A;
            end
            B: begin
                out = 1'b0;
                if (in) state = B;
                else    state = C;
            end
            C: begin
                out = 1'b0;
                if (in) state = D;
                else    state = A;
            end
            D: begin
                out = 1'b1;
                if (in) state = B;
                else    state = C;
            end
            default: begin
                out = 1'b0;
                state = A;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= state;
    end

endmodule