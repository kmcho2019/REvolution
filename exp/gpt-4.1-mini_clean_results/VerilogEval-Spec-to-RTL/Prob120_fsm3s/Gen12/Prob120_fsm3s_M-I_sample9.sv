module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] state, next_state;
    reg       next_out;

    // Combined next state and output combinational logic
    always @(*) begin
        case (state)
            A: begin
                next_state = (in == 1'b0) ? A : B;
                next_out   = 1'b0;
            end
            B: begin
                next_state = (in == 1'b0) ? C : B;
                next_out   = 1'b0;
            end
            C: begin
                next_state = (in == 1'b0) ? A : D;
                next_out   = 1'b0;
            end
            D: begin
                next_state = (in == 1'b0) ? C : B;
                next_out   = 1'b1;
            end
            default: begin
                next_state = A;
                next_out   = 1'b0;
            end
        endcase
    end

    // State and output registers with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= next_out;
        end
    end

endmodule