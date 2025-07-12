module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0] == 1) begin
                next_state = 2'b01; // Go to state B
            end else if (r[1] == 1) begin
                next_state = 2'b10; // Go to state C
            end else if (r[2] == 1) begin
                next_state = 2'b00; // Stay in state A
            end else begin
                next_state = 2'b00; // Stay in state A
            end
        2'b01: // State B
            if (r[0] == 1) begin
                next_state = 2'b01; // Stay in state B
            end else begin
                next_state = 2'b00; // Go to state A
            end
        2'b10: // State C
            if (r[1] == 1) begin
                next_state = 2'b10; // Stay in state C
            end else begin
                next_state = 2'b00; // Go to state A
            end
        default: next_state = 2'b00; // Stay in state A
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state; // Update state
    end
end

always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0] == 0 && r[1] == 0 && r[2] == 1) begin
                g[0] = 0;
                g[1] = 0;
                g[2] = 1;
            end else begin
                g[0] = 0;
                g[1] = 0;
                g[2] = 0;
            end
        2'b01: // State B
            begin
                g[0] = 1;
                g[1] = 0;
                g[2] = 0;
            end
        2'b10: // State C
            begin
                g[0] = 0;
                g[1] = 1;
                g[2] = 0;
            end
        default: begin
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
    endcase
end

endmodule