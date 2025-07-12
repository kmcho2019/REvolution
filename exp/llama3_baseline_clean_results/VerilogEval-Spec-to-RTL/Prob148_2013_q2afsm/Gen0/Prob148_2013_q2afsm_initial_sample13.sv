module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0] == 1'b1)
                next_state = 2'b01; // State B
            else if (r[1] == 1'b1)
                next_state = 2'b10; // State C
            else
                next_state = 2'b00; // State A
        2'b01: // State B
            if (r[0] == 1'b1)
                next_state = 2'b01; // State B
            else
                next_state = 2'b00; // State A
        2'b10: // State C
            if (r[1] == 1'b1)
                next_state = 2'b10; // State C
            else
                next_state = 2'b00; // State A
        default: next_state = 2'b00; // Default state A
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: // State A
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
        2'b01: // State B
            g[0] = 1'b1;
            g[1] = 1'b0;
            g[2] = 1'b0;
        2'b10: // State C
            g[0] = 1'b0;
            g[1] = 1'b1;
            g[2] = 1'b0;
        default:
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
    endcase
end

endmodule