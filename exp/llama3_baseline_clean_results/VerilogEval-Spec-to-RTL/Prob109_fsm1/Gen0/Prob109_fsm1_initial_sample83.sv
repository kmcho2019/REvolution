module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // Using a 1-bit reg to represent the states A and B
parameter A = 0, B = 1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B; // Asynchronous reset to state B
    end else begin
        case(state)
            A: begin
                if (~in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            B: begin
                if (~in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
        endcase
    end
end

assign out = (state == B) ? 1 : 0; // Output out is 1 in state B, 0 in state A

endmodule