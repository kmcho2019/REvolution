module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // State register to hold the current state
reg [1:0] x_sequence_counter; // Counter for x input sequence
reg [1:0] y_wait_counter; // Counter for waiting for y
reg f_out; // Output f
reg g_out; // Output g

// State encoding
parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;
parameter STATE_E = 3'b100;
parameter STATE_F = 3'b101;

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin // Reset condition
        state <= STATE_A;
        f_out <= 0;
        g_out <= 0;
        x_sequence_counter <= 0;
        y_wait_counter <= 0;
    end else begin
        case(state)
            STATE_A: begin // Waiting for reset to be deasserted
                if (resetn) begin
                    state <= STATE_B;
                end
                f_out <= 0;
                g_out <= 0;
            end
            STATE_B: begin // Set f to 1 for one cycle
                state <= STATE_C;
                f_out <= 1;
                g_out <= 0;
            end
            STATE_C: begin // Monitor x for sequence 1, 0, 1
                if (x_sequence_counter == 0 && x) begin
                    x_sequence_counter <= x_sequence_counter + 1;
                end else if (x_sequence_counter == 1 && ~x) begin
                    x_sequence_counter <= x_sequence_counter + 1;
                end else if (x_sequence_counter == 2 && x) begin
                    x_sequence_counter <= 0;
                    state <= STATE_D;
                end else begin
                    x_sequence_counter <= 0; // Reset sequence counter if x does not match sequence
                end
                f_out <= 0; // Reset f after one cycle
                g_out <= 0;
            end
            STATE_D: begin // Wait for y within two cycles after g is set
                g_out <= 1;
                if (y) begin // If y is high within two cycles, maintain g
                    state <= STATE_E;
                end else if (y_wait_counter == 1) begin // If y is not high within two cycles, set g to 0
                    state <= STATE_F;
                end else begin
                    y_wait_counter <= y_wait_counter + 1;
                end
            end
            STATE_E: begin // Maintain g = 1
                g_out <= 1;
            end
            STATE_F: begin // Maintain g = 0
                g_out <= 0;
            end
            default: begin
                state <= STATE_A; // Default to STATE_A if unexpected state occurs
                f_out <= 0;
                g_out <= 0;
            end
        endcase
    end
end

assign f = f_out;
assign g = g_out;

endmodule