module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 3'd0;
localparam STATE_B = 3'd1;
localparam STATE_C = 3'd2;
localparam STATE_D = 3'd3;
localparam STATE_E = 3'd4;
localparam STATE_F = 3'd5;
localparam STATE_G = 3'd6;

reg [2:0] current_state, next_state;
reg [1:0] timeout_counter;
reg f_reg, g_reg;

// State transition logic
always @(*) begin
    case (current_state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: next_state = x ? STATE_D : STATE_C;
        STATE_D: next_state = !x ? STATE_E : STATE_D;
        STATE_E: next_state = x ? STATE_F : STATE_C;
        STATE_F: begin
            if (y) next_state = STATE_G;
            else if (timeout_counter == 2'd1) next_state = STATE_G;
            else next_state = STATE_F;
        end
        STATE_G: next_state = STATE_G;
        default: next_state = STATE_A;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= STATE_A;
        timeout_counter <= 0;
    end
    else begin
        current_state <= next_state;
        
        // Timeout counter
        if (current_state == STATE_F && !y && timeout_counter < 2'd1)
            timeout_counter <= timeout_counter + 1;
        else if (current_state != STATE_F)
            timeout_counter <= 0;
    end
end

// Output logic
always @(*) begin
    case (current_state)
        STATE_A: begin f_reg = 0; g_reg = 0; end
        STATE_B: begin f_reg = 1; g_reg = 0; end
        STATE_C: begin f_reg = 0; g_reg = 0; end
        STATE_D: begin f_reg = 0; g_reg = 0; end
        STATE_E: begin f_reg = 0; g_reg = x; end
        STATE_F: begin f_reg = 0; g_reg = 1; end
        STATE_G: begin f_reg = 0; g_reg = (timeout_counter != 2'd1); end
        default: begin f_reg = 0; g_reg = 0; end
    endcase
end

assign f = f_reg;
assign g = g_reg;

endmodule