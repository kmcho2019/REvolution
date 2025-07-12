module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // 0: A, 1: B
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // reset to state B
    end else begin
        case (state)
            0: begin // state A
                if (!in) begin
                    next_state <= 1; // next state B
                    out <= 0;
                end else begin
                    next_state <= 0; // next state A
                    out <= 0;
                end
            end
            1: begin // state B
                if (in) begin
                    next_state <= 1; // next state B
                    out <= 1;
                end else begin
                    next_state <= 0; // next state A
                    out <= 1;
                end
            end
        endcase
        state <= next_state;
    end
end

endmodule