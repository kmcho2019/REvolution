module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam RESET        = 2'b00;
localparam PULSE_F      = 2'b01;
localparam WAIT_FOR_SEQ = 2'b10;
localparam LOCKED       = 2'b11;

reg [1:0] state;
reg [2:0] x_history;
reg [1:0] y_timer;
reg g_reg;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_history <= 3'b000;
        y_timer <= 2'b00;
        g_reg <= 1'b0;
    end else begin
        x_history <= {x_history[1:0], x};
        
        case (state)
            RESET: 
                state <= PULSE_F;
                
            PULSE_F: 
                state <= WAIT_FOR_SEQ;
                
            WAIT_FOR_SEQ: begin
                if (x_history == 3'b101) begin
                    g_reg <= 1'b1;
                    y_timer <= 2'b00;
                end
                
                if (g_reg) begin
                    if (y) begin
                        state <= LOCKED;
                    end else if (y_timer == 2'b01) begin
                        g_reg <= 1'b0;
                        state <= LOCKED;
                    end
                    y_timer <= y_timer + 1;
                end
            end
            
            LOCKED: 
                // Stay in locked state until reset
                state <= LOCKED;
        endcase
    end
end

// Output logic
assign f = (state == PULSE_F);
assign g = (state == LOCKED) ? g_reg : 
           ((state == WAIT_FOR_SEQ) && g_reg && !(y_timer == 2'b10));

endmodule