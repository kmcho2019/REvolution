module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 3'd0;  // Reset state
localparam STATE_B = 3'd1;  // f=1 pulse state
localparam STATE_C = 3'd2;  // x sequence detection
localparam STATE_D = 3'd3;  // g=1, monitoring y
localparam STATE_E = 3'd4;  // Final state (g permanent)

reg [2:0] current_state, next_state;
reg [2:0] x_history;  // Shift register for x sequence
reg [1:0] timeout_count;
reg f_reg, g_reg;

// Sequential state transition
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= STATE_A;
        x_history <= 3'b0;
        timeout_count <= 2'b0;
    end else begin
        current_state <= next_state;
        x_history <= {x_history[1:0], x};
        
        if (current_state == STATE_D) begin
            timeout_count <= timeout_count + 1;
        end else begin
            timeout_count <= 2'b0;
        end
    end
end

// Combinational next state and output logic
always @(*) begin
    // Default outputs
    f_reg = 1'b0;
    g_reg = 1'b0;
    next_state = current_state;

    case (current_state)
        STATE_A: begin
            if (resetn) next_state = STATE_B;
        end
        
        STATE_B: begin
            f_reg = 1'b1;
            next_state = STATE_C;
        end
        
        STATE_C: begin
            if (x_history == 3'b101) begin
                g_reg = 1'b1;
                next_state = STATE_D;
            end
        end
        
        STATE_D: begin
            g_reg = 1'b1;
            if (y) begin
                next_state = STATE_E;
            end else if (timeout_count == 2'd1) begin
                g_reg = 1'b0;
                next_state = STATE_E;
            end
        end
        
        STATE_E: begin
            g_reg = (current_state == STATE_D) ? 1'b1 : g_reg;
        end
    endcase
end

assign f = f_reg;
assign g = g_reg;

endmodule