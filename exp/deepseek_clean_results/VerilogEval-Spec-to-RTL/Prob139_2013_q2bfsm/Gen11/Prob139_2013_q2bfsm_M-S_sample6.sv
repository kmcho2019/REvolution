module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 2'd0;
localparam STATE_B = 2'd1;
localparam STATE_C = 2'd2;
localparam STATE_D = 2'd3;

reg [1:0] state;
reg [1:0] x_history;  // Shift register for x inputs
reg g_perm;           // Permanent g value
reg timeout_flag;     // Tracks if we're in 2nd cycle of STATE_D

// Output logic
assign f = (state == STATE_B);
assign g = g_perm || (state == STATE_D && y);

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 2'b00;
        g_perm <= 0;
        timeout_flag <= 0;
    end else begin
        // Update x history
        x_history <= {x_history[0], x};

        case (state)
            STATE_A: state <= STATE_B;
            
            STATE_B: state <= STATE_C;
            
            STATE_C: begin
                if (x_history == 2'b01 && x)  // Detected 1-0-1 sequence
                    state <= STATE_D;
            end
            
            STATE_D: begin
                if (y) begin
                    g_perm <= 1;  // Permanent g=1
                end else if (timeout_flag) begin
                    g_perm <= 0;  // Permanent g=0
                end else begin
                    timeout_flag <= 1;  // Mark first timeout cycle
                end
            end
        endcase
    end
end

endmodule