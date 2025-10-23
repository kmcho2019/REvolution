module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1;  // asynchronously reset to state B
    end else begin
        case (state)
            0: begin  // state A
                if (!in) begin
                    state <= 1;  // transition to state B if input is 0
                end else begin
                    state <= 0;  // remain in state A if input is 1
                end
            end
            1: begin  // state B
                state <= 1;  // remain in state B regardless of input
            end
        endcase
    end
end

assign out = state;

endmodule