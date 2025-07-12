module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;
localparam E = 2'd4;

reg [2:0] state;
reg [1:0] x_shift;  // Shift register for x sequence
reg [1:0] timeout;
reg g_permanent;    // Stores final g value

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_shift <= 2'b00;
        timeout <= 2'b00;
        g_permanent <= 1'b0;
    end
    else begin
        // Shift register for x sequence detection
        x_shift <= {x_shift[0], x};

        case (state)
            A: state <= B;  // Move to pulse state after reset
            B: state <= C;  // One-cycle pulse for f
            C: begin
                if (x_shift == 2'b10 && x)  // Detected 1-0-1
                    state <= D;
            end
            D: begin
                if (y) begin
                    g_permanent <= 1'b1;
                    state <= E;
                end
                else if (timeout == 2'b10) begin  // 2 cycles elapsed
                    g_permanent <= 1'b0;
                    state <= E;
                end
                else
                    timeout <= timeout + 1;
            end
            E: state <= E;  // Permanent state
        endcase
    end
end

// Output logic
assign f = (state == B);
assign g = (state == D) || (state == E && g_permanent);

endmodule