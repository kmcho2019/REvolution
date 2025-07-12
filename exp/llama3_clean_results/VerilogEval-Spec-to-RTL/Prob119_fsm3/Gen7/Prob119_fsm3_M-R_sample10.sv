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
            A: begin
                state <= in ? B : A;
                out <= 1'b0;
            end
            B: begin
                state <= in ? B : C;
                out <= 1'b0;
            end
            C: begin
                state <= in ? D : A;
                out <= 1'b0;
            end
            D: begin
                state <= in ? B : C;
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