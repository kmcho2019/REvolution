module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state; // 0 for state A, 1 for state B

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // asynchronously reset to state B
        out <= 1'b1;
    end else begin
        case (state)
            1'b0: begin // state A
                if (~in) begin
                    state <= 1'b1; // A --0--> B
                    out <= 1'b1;
                end else begin
                    state <= 1'b0; // A --1--> A
                    out <= 1'b0;
                end
            end
            1'b1: begin // state B
                if (~in) begin
                    state <= 1'b0; // B --0--> A
                    out <= 1'b0;
                end else begin
                    state <= 1'b1; // B --1--> B
                    out <= 1'b1;
                end
            end
        endcase
    end
end

endmodule