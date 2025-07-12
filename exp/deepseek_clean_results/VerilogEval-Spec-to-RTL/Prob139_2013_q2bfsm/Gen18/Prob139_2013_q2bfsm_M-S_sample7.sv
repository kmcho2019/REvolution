module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output reg g
);

reg [2:0] state;
reg [1:0] x_history;
reg y_timeout;
wire pattern_match;

localparam RESET    = 3'b000;
localparam PULSE_F  = 3'b001;
localparam MONITOR_X = 3'b010;
localparam MONITOR_Y = 3'b011;
localparam FINAL    = 3'b100;

assign pattern_match = (x_history == 2'b10) & x; // Detect 1-0-1 sequence
assign f = (state == PULSE_F);

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        g <= 0;
        x_history <= 0;
        y_timeout <= 0;
    end else begin
        // Update x history for pattern detection
        x_history <= {x_history[0], x};
        
        case (state)
            RESET: begin
                state <= PULSE_F;
            end
            
            PULSE_F: begin
                state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                if (pattern_match) begin
                    state <= MONITOR_Y;
                    y_timeout <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    g <= 1;
                    state <= FINAL;
                end else if (y_timeout) begin
                    g <= 0;
                    state <= FINAL;
                end else begin
                    y_timeout <= 1;
                    g <= 1; // Set g one cycle after pattern match
                end
            end
            
            FINAL: begin
                // g maintains its value until reset
            end
        endcase
    end
end

endmodule