module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam RESET     = 2'b00;
localparam PULSE_F   = 2'b01;
localparam MONITOR_X = 2'b10;
localparam FINAL     = 2'b11;

reg [1:0] state;
reg [2:0] x_shift;
reg y_timeout;
reg g_reg;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_shift <= 3'b000;
        y_timeout <= 1'b0;
        g_reg <= 1'b0;
    end else begin
        x_shift <= {x_shift[1:0], x};  // Shift in new x value
        
        case (state)
            RESET: 
                state <= PULSE_F;
                
            PULSE_F: 
                state <= MONITOR_X;
                
            MONITOR_X: begin
                if (x_shift == 3'b101) begin
                    state <= FINAL;
                    g_reg <= 1'b1;      // Set g when sequence detected
                    y_timeout <= 1'b0;  // Start y monitoring
                end
            end
                
            FINAL: begin
                if (y) begin
                    // Keep g_reg permanently at 1
                    y_timeout <= 1'b0;
                end else if (!y_timeout) begin
                    // First cycle in FINAL without y=1
                    y_timeout <= 1'b1;
                end else begin
                    // Second cycle in FINAL without y=1
                    g_reg <= 1'b0;     // Permanently set g to 0
                end
            end
        endcase
    end
end

// Output logic
assign f = (state == PULSE_F);
assign g = g_reg;

endmodule