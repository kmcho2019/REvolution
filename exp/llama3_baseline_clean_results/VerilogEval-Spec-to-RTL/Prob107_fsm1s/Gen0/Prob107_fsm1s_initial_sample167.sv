module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // 0 - state A, 1 - state B

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset to state B
    end else begin
        case (state)
            0: begin // State A
                if (~in) begin
                    state <= 1; // A (out=0) --in=0--> B
                end else begin
                    state <= 0; // A (out=0) --in=1--> A
                end
            end
            1: begin // State B
                if (~in) begin
                    state <= 0; // B (out=1) --in=0--> A
                end else begin
                    state <= 1; // B (out=1) --in=1--> B
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: out = 0; // State A
        1: out = 1; // State B
    endcase
end

endmodule