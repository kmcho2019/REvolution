module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding (2 bits)
localparam STATE_A = 2'd0;  // Reset state
localparam STATE_B = 2'd1;  // f=1 pulse state
localparam STATE_C = 2'd2;  // Monitoring x sequence
localparam STATE_D = 2'd3;  // Monitoring y with timeout

reg [1:0] state, next_state;
reg [2:0] x_sequence;  // Shift register for x inputs
reg timeout_counter;    // 1-bit counter for 2-cycle timeout
reg g_permanent;        // Permanent g value (1 or 0)

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_sequence <= 3'b000;
        timeout_counter <= 0;
        g_permanent <= 0;
    end else begin
        state <= next_state;
        x_sequence <= {x_sequence[1:0], x};
        
        // Update timeout counter in STATE_D
        if (state == STATE_D && !g_permanent) begin
            timeout_counter <= timeout_counter + 1;
        end else begin
            timeout_counter <= 0;
        end
        
        // Set g_permanent when conditions met
        if (state == STATE_D) begin
            if (y) begin
                g_permanent <= 1;
            end else if (timeout_counter) begin
                g_permanent <= 0;
            end
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: next_state = (x_sequence == 3'b101) ? STATE_D : STATE_C;
        STATE_D: next_state = (g_permanent) ? STATE_D : STATE_D; // Stay until reset
        default: next_state = STATE_A;
    endcase
end

// Output assignments
assign f = (state == STATE_B);
assign g = g_permanent || (state == STATE_D && y); // Current or permanent g

endmodule