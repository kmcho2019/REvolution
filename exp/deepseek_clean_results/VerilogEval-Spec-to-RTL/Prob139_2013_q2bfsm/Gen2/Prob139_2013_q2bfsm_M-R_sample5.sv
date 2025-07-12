module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// One-hot state encoding
localparam STATE_A = 3'b001;
localparam STATE_B = 3'b010;
localparam STATE_C = 3'b100;

reg [2:0] state, next_state;
reg [2:0] x_shift;  // 3-bit shift register for sequence detection
reg [1:0] timeout_count;
reg f_reg, g_reg;

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_shift <= 3'b0;
        timeout_count <= 2'b0;
    end else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};  // Shift in new x value
        
        // Update timeout counter only in STATE_C
        if (state == STATE_C && !y && timeout_count < 2)
            timeout_count <= timeout_count + 1;
        else if (state != STATE_C)
            timeout_count <= 2'b0;
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: begin
            if (y || timeout_count == 2)
                next_state = STATE_C;  // Stay permanently
            else
                next_state = STATE_C;  // Continue waiting
        end
        default: next_state = STATE_A;
    endcase
end

// Output logic (combinational)
assign f = (state == STATE_B);
assign g = (state == STATE_C) && ((y == 1) || (timeout_count == 2) || (x_shift == 3'b101));

// Register outputs for clean timing
always @(posedge clk) begin
    if (!resetn) begin
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        f_reg <= f;
        g_reg <= g;
    end
end

// Final registered outputs
assign f = f_reg;
assign g = g_reg;

endmodule