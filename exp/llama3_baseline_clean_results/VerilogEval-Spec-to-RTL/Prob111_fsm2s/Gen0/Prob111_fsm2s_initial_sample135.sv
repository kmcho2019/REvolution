module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // 0: OFF, 1: ON
parameter OFF = 1'b0;
parameter ON = 1'b1;

always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
        endcase
    end
end

always @(state) begin
    case(state)
        OFF: out <= 0;
        ON: out <= 1;
    endcase
end

endmodule