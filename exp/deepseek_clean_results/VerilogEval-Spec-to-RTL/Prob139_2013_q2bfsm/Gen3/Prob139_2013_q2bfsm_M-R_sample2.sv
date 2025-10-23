module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam A = 3'd0;
localparam B = 3'd1;
localparam C = 3'd2;
localparam D = 3'd3;
localparam E = 3'd4;
localparam F = 3'd5;
localparam G = 3'd6;

reg [2:0] state;
reg [1:0] timeout;
reg last_x, prev_x;  // For sequence detection

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        timeout <= 0;
        last_x <= 0;
        prev_x <= 0;
    end
    else begin
        // Shift register for x sequence detection
        prev_x <= last_x;
        last_x <= x;

        case (state)
            A: state <= B;  // Move to pulse state after reset
            B: state <= C;  // One-cycle pulse for f
            C: if (x) state <= D;  // First '1' detected
            D: if (!x) state <= E;  // '0' detected after '1'
            E: if (x) state <= F;  // Complete '1-0-1' sequence
            F: begin
                if (y) begin
                    state <= G;
                end
                else if (timeout == 2'd1) begin
                    state <= G;
                end
                else begin
                    timeout <= timeout + 1;
                end
            end
            G: state <= G;  // Permanent state
            default: state <= A;
        endcase
    end
end

// Output logic
assign f = (state == B);
assign g = (state == F) || (state == G && timeout != 2'd1);

endmodule