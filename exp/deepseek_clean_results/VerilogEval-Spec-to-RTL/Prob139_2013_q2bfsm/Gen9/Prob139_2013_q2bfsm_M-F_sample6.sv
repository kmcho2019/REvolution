module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 2'd0;  // Reset state
localparam STATE_B = 2'd1;  // f=1 pulse state
localparam STATE_C = 2'd2;  // Monitoring x sequence
localparam STATE_D = 2'd3;  // Monitoring y with timeout
localparam STATE_E = 3'd4;  // Permanent state (needs extra bit)

reg [2:0] state;  // Extra bit for STATE_E
reg [1:0] x_history;  // Track last 2 x values (current x is separate)
reg timeout_counter;  // 1-bit counter for 2-cycle timeout
reg g_reg;

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 2'b00;
        timeout_counter <= 0;
        g_reg <= 0;
    end else begin
        case (state)
            STATE_A: state <= STATE_B;
            STATE_B: state <= STATE_C;
            STATE_C: begin
                x_history <= {x_history[0], x};
                if (x_history == 2'b10 && x == 1'b1)
                    state <= STATE_D;
            end
            STATE_D: begin
                if (y) begin
                    state <= STATE_E;
                    g_reg <= 1;
                end else if (timeout_counter) begin
                    state <= STATE_E;
                    g_reg <= 0;
                end
                timeout_counter <= ~timeout_counter;
            end
            STATE_E: state <= STATE_E;  // Stay until reset
        endcase
    end
end

// Output logic (combinational for f, registered for g)
assign f = (state == STATE_B);
assign g = g_reg;

endmodule