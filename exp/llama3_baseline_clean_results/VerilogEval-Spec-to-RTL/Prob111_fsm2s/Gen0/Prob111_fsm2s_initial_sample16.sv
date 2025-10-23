module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] current_state; // Using 2-state encoding (0 for OFF, 1 for ON)
parameter OFF = 1'b0;
parameter ON = 1'b1;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Active-high synchronous reset
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: begin
                if (j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
            default: current_state <= OFF;
        endcase
    end
end

assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule