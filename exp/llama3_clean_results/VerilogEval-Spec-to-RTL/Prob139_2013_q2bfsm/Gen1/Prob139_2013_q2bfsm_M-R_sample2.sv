module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State enumeration
enum logic [1:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D
} state, next_state;

// Shift register for x sequence detection
reg [1:0] x_reg;

// Flag to indicate y has been seen in STATE_D
reg y_seen;

// Assign output f
assign f = (state == STATE_B);

// Always block for state transitions and register updates
always @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
        x_reg <= 0;
        y_seen <= 0;
        g <= 0;
    end else begin
        case (state)
            STATE_A: begin
                state <= STATE_B;
            end
            STATE_B: begin
                state <= STATE_C;
                x_reg <= x;
            end
            STATE_C: begin
                x_reg <= {x, x_reg[1]};
                if (x_reg == 5) begin // 1, 0, 1 sequence detected
                    state <= STATE_D;
                    g <= 1;
                    y_seen <= 0;
                end
            end
            STATE_D: begin
                if (~y_seen && y) begin
                    y_seen <= 1;
                end
                if (y_seen || (~y_seen && (x_reg[1] || x_reg[0]))) begin
                    g <= 1;
                end else if (~y_seen) begin
                    g <= 0;
                end
            end
        endcase
    end
end

endmodule