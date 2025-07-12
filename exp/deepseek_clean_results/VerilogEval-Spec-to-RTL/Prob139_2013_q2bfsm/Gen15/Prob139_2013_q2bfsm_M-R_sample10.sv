module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 2'b00;  // Initial/reset state
localparam STATE_B = 2'b01;  // Pulse f state
localparam STATE_C = 2'b10;  // Monitor for 101 pattern
localparam STATE_D1 = 2'b11; // First y monitoring cycle
localparam STATE_D2 = 3'b100; // Second y monitoring cycle
localparam STATE_FINAL = 3'b101; // Final state (g permanent)

reg [2:0] state, next_state;
reg [2:0] x_shift;  // 3-bit shift register for pattern detection

// Output logic
assign f = (state == STATE_B);
assign g = (state == STATE_D1 || state == STATE_D2 || state == STATE_FINAL) && 
           (state != STATE_FINAL || y_was_1);

reg y_was_1;  // Flag for permanent g=1 condition

// State transition logic
always @(*) begin
    next_state = state;
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: begin
            if (x_shift == 3'b101)
                next_state = STATE_D1;
        end
        STATE_D1: begin
            if (y) begin
                next_state = STATE_FINAL;
                y_was_1 = 1'b1;
            end
            else
                next_state = STATE_D2;
        end
        STATE_D2: begin
            if (y) begin
                next_state = STATE_FINAL;
                y_was_1 = 1'b1;
            end
            else
                next_state = STATE_FINAL;
        end
        STATE_FINAL: next_state = STATE_FINAL;  // Stay permanently
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_shift <= 3'b0;
        y_was_1 <= 1'b0;
    end
    else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};  // Shift in new x value
        
        if (state == STATE_A)
            y_was_1 <= 1'b0;
    end
end

endmodule