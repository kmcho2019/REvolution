module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 3'b000;  // Reset state
localparam STATE_B = 3'b001;  // f=1 pulse state
localparam STATE_C = 3'b010;  // Waiting for x sequence
localparam STATE_D = 3'b011;  // g=1, monitoring y
localparam STATE_E = 3'b100;  // g=1 permanently
localparam STATE_F = 3'b101;  // g=0 permanently

reg [2:0] state, next_state;
reg f_reg, g_reg;
reg [1:0] x_history;  // Shift register for x sequence
reg timeout_counter;   // 1-bit counter for y timeout

// Continuous assignments for outputs
assign f = f_reg;
assign g = g_reg;

// State transition logic
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 2'b00;
        timeout_counter <= 0;
    end else begin
        state <= next_state;
        x_history <= {x_history[0], x};  // Shift in new x value
        
        if (state == STATE_D)
            timeout_counter <= timeout_counter + 1;
        else
            timeout_counter <= 0;
    end
end

// Next state and output logic
always @(*) begin
    case (state)
        STATE_A: begin
            f_reg = 0;
            g_reg = 0;
            next_state = STATE_B;
        end
        
        STATE_B: begin
            f_reg = 1;
            g_reg = 0;
            next_state = STATE_C;
        end
        
        STATE_C: begin
            f_reg = 0;
            g_reg = 0;
            if (x_history == 2'b10 && x)  // Detected 1,0,1 sequence
                next_state = STATE_D;
            else
                next_state = STATE_C;
        end
        
        STATE_D: begin
            f_reg = 0;
            g_reg = 1;
            if (y)
                next_state = STATE_E;
            else if (timeout_counter)
                next_state = STATE_F;
            else
                next_state = STATE_D;
        end
        
        STATE_E: begin
            f_reg = 0;
            g_reg = 1;
            next_state = STATE_E;
        end
        
        STATE_F: begin
            f_reg = 0;
            g_reg = 0;
            next_state = STATE_F;
        end
        
        default: begin
            f_reg = 0;
            g_reg = 0;
            next_state = STATE_A;
        end
    endcase
end

endmodule