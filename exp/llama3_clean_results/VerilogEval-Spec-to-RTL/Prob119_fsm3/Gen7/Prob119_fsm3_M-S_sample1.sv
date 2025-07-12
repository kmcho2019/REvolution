module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 2'd0;
parameter B = 2'd1;
parameter C = 2'd2;
parameter D = 2'd3;

// Define the state register
reg [1:0] state;

// Sequential logic for state update and output with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        out <= 1'b0;
    end else begin
        case (state)
            A: if (in) state <= B; else state <= A;
            B: if (in) state <= B; else state <= C;
            C: if (in) state <= D; else state <= A;
            D: if (in) state <= B; else state <= C;
            default: state <= A;
        endcase
        case (state)
            A, B, C: out <= 1'b0;
            D: out <= 1'b1;
            default: out <= 1'b0;
        endcase
    end
end

endmodule