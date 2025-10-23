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
localparam STATE_E = 2'd4;  // Permanent state (unused, handled separately)

reg [1:0] state, next_state;
reg [2:0] x_sequence;  // Shift register for x inputs
reg timeout_flag;      // Indicates timeout occurred
reg g_permanent;       // Permanent g value

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_sequence <= 3'b000;
        timeout_flag <= 0;
        g_permanent <= 0;
    end else begin
        state <= next_state;
        
        // Update x sequence shift register
        x_sequence <= {x_sequence[1:0], x};
        
        // Set timeout flag if y not detected within 2 cycles
        if (state == STATE_D && !y) begin
            if (timeout_flag) begin
                g_permanent <= 0;
            end else begin
                timeout_flag <= 1;
            end
        end else if (state != STATE_D) begin
            timeout_flag <= 0;
        end
        
        // Set g permanently if y detected
        if (state == STATE_D && y) begin
            g_permanent <= 1;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: next_state = (x_sequence == 3'b101) ? STATE_D : STATE_C;
        STATE_D: next_state = (g_permanent || timeout_flag) ? STATE_C : STATE_D;
        default: next_state = STATE_A;
    endcase
end

// Output assignments
assign f = (state == STATE_B);
assign g = (state == STATE_D) ? (y || g_permanent) : 
           (g_permanent && resetn);  // Maintain g if permanently set

endmodule