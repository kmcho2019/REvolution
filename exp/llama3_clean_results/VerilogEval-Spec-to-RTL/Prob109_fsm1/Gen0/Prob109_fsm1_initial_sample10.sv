module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] state; // Encoding for states: 1 for B, 0 for A
parameter B = 1'b1, A = 1'b0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        case (state)
            B: begin
                if (~in) begin
                    state <= A;
                end
            end
            A: begin
                state <= B; // Transition to B regardless of 'in'
            end
            default: state <= B; // Default to B if state becomes invalid
        endcase
    end
end

assign out = (state == B) ? 1'b1 : 1'b0;

endmodule