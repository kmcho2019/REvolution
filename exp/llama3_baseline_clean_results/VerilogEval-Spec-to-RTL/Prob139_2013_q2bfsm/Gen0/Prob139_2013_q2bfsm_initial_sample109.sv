module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state; // Enumerates states: A=0, B=1, C=2, D=3, E=4, F=5
reg [1:0] x_seq_count; // Counts the sequence of x
reg [1:0] y_wait_count; // Waits for y=1 in state D
reg f_reg, g_reg; // Registers for outputs f and g

always @(posedge clk) begin
    if (!resetn) begin // Reset condition
        state <= 0; // State A
        f_reg <= 0;
        g_reg <= 0;
        x_seq_count <= 0;
        y_wait_count <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) state <= 1; // Move to State B when resetn is high
            end
            1: begin // State B
                f_reg <= 1; // Set f=1
                state <= 2; // Move to State C
            end
            2: begin // State C
                f_reg <= 0; // Reset f after one cycle
                if (x == 1 && x_seq_count == 0) x_seq_count <= 1;
                else if (x == 0 && x_seq_count == 1) x_seq_count <= 2;
                else if (x == 1 && x_seq_count == 2) begin
                    x_seq_count <= 0; // Reset sequence counter
                    state <= 3; // Move to State D
                end else x_seq_count <= 0; // Reset on mismatch
            end
            3: begin // State D
                g_reg <= 1; // Set g=1
                if (y == 1) state <= 4; // Move to State E if y=1
                else if (y_wait_count == 0) y_wait_count <= 1;
                else if (y_wait_count == 1) begin
                    y_wait_count <= 2;
                    if (y == 1) state <= 4; // Move to State E if y=1 on second cycle
                    else state <= 5; // Move to State F if y still 0
                end
            end
            4: begin // State E
                // Do nothing, g=1 permanently
            end
            5: begin // State F
                g_reg <= 0; // Set g=0 permanently
                // Do nothing
            end
            default: state <= 0; // Default to State A on any other condition
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule