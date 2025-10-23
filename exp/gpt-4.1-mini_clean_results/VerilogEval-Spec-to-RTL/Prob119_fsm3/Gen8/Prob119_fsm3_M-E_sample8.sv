module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// One-hot encoding for states
localparam A = 4'b0001,
           B = 4'b0010,
           C = 4'b0100,
           D = 4'b1000;

reg [3:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        out <= 1'b0;
    end else begin
        case (1'b1) // synthesize priority mux for one-hot
            state[0]: begin // State A
                if (in) state <= B;
                else    state <= A;
                out <= 1'b0;
            end
            state[1]: begin // State B
                if (in) state <= B;
                else    state <= C;
                out <= 1'b0;
            end
            state[2]: begin // State C
                if (in) state <= D;
                else    state <= A;
                out <= 1'b0;
            end
            state[3]: begin // State D
                if (in) state <= B;
                else    state <= C;
                out <= 1'b1;
            end
            default: begin
                state <= A;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule