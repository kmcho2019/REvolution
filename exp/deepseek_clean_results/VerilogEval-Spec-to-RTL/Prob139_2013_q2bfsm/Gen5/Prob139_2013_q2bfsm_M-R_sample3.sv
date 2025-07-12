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
localparam STATE_C = 2'd2;  // x sequence detection
localparam STATE_D = 2'd3;  // g active, monitoring y

reg [1:0] state;
reg [2:0] x_shift;    // Shift register for x sequence
reg timeout;          // Flag for y timeout

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_shift <= 3'b0;
        timeout <= 1'b0;
    end else begin
        case (state)
            STATE_A: state <= STATE_B;
            
            STATE_B: begin
                state <= STATE_C;
                x_shift <= 3'b0;
            end
            
            STATE_C: begin
                x_shift <= {x_shift[1:0], x};
                if (x_shift == 3'b101) begin
                    state <= STATE_D;
                    timeout <= 1'b0;
                end
            end
            
            STATE_D: begin
                if (y) begin
                    // Stay in STATE_D permanently
                end else if (!timeout) begin
                    timeout <= 1'b1;
                end
            end
        endcase
    end
end

// Output logic
assign f = (state == STATE_B);
assign g = (state == STATE_D) && (!timeout || y);

endmodule