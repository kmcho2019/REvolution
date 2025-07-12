module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam RESET   = 2'b00;
localparam F_PULSE = 2'b01;
localparam MONITOR = 2'b10;
localparam FINAL   = 2'b11;

reg [1:0] state;
reg [2:0] x_history;  // Stores last 3 x values
reg [1:0] y_timer;    // Counts cycles after 101 pattern
reg f_reg;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_history <= 0;
        y_timer <= 0;
        f_reg <= 0;
    end else begin
        // Shift in new x value
        x_history <= {x_history[1:0], x};
        
        case (state)
            RESET: begin
                state <= F_PULSE;
                f_reg <= 1;
            end
            
            F_PULSE: begin
                state <= MONITOR;
                f_reg <= 0;
            end
            
            MONITOR: begin
                if (x_history == 3'b101) begin
                    if (y) begin
                        state <= FINAL;
                    end else if (y_timer == 2'b01) begin
                        state <= FINAL;
                    end
                    y_timer <= y_timer + 1;
                end
            end
            
            FINAL: begin
                // Stay in final state
            end
        endcase
    end
end

// Output assignments
assign f = f_reg;
assign g = (state == FINAL) && (y || (x_history == 3'b101 && y_timer < 2));

endmodule