module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // Two states: 0 (OFF) and 1 (ON)
localparam OFF = 1'b0;
localparam ON  = 1'b1;

always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                    out <= 1'b1;
                end else begin
                    state <= OFF;
                    out <= 1'b0;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                    out <= 1'b0;
                end else begin
                    state <= ON;
                    out <= 1'b1;
                end
            end
            default: state <= OFF;
        endcase
    end
end

endmodule