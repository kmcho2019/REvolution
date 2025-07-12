module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// One-hot state encoding
localparam INIT      = 3'b001;
localparam WAIT_PAT  = 3'b010;
localparam MONITOR_1 = 3'b100;
localparam MONITOR_2 = 3'b101;  // Extra bit indicates permanent status

reg [2:0] state;
reg [2:0] x_shift;
reg f_reg, g_reg;

// Pattern detection
wire pattern_detected = (x_shift == 3'b101);

// Output assignments
assign f = f_reg;
assign g = g_reg;

always @(posedge clk) begin
    if (!resetn) begin
        state <= INIT;
        f_reg <= 1'b0;
        g_reg <= 1'b0;
        x_shift <= 3'b0;
    end
    else begin
        // Shift x input for pattern detection
        x_shift <= {x_shift[1:0], x};
        
        case (state)
            INIT: begin
                f_reg <= 1'b1;
                g_reg <= 1'b0;
                state <= WAIT_PAT;
            end
            
            WAIT_PAT: begin
                f_reg <= 1'b0;
                if (pattern_detected) begin
                    g_reg <= 1'b1;
                    state <= MONITOR_1;
                end
            end
            
            MONITOR_1: begin
                if (y) begin
                    state <= MONITOR_2;  // Permanent g=1
                end
                else begin
                    state <= MONITOR_2;  // Will set g=0 next cycle
                end
            end
            
            MONITOR_2: begin
                if (state[0]) begin  // Came from MONITOR_1 directly
                    if (y) begin
                        // Keep g=1 permanently
                        state <= MONITOR_2;
                    end
                    else begin
                        g_reg <= 1'b0;  // Set g=0 permanently
                        state <= MONITOR_2;
                    end
                end
                // Otherwise maintain current state and outputs
            end
        endcase
    end
end

endmodule