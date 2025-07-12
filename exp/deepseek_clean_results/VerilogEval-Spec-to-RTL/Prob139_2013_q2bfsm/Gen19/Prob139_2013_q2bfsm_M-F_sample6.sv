module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output reg g
);

reg [2:0] state;
reg [2:0] x_shift;
reg [1:0] y_counter;
wire pattern_match;

localparam RESET     = 3'b000;
localparam PULSE_F   = 3'b001;
localparam MONITOR_X = 3'b010;
localparam MONITOR_Y = 3'b011;
localparam FINAL_HIGH = 3'b100;
localparam FINAL_LOW = 3'b101;

assign pattern_match = (x_shift == 3'b101);
assign f = (state == PULSE_F);

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        g <= 0;
        x_shift <= 0;
        y_counter <= 0;
    end else begin
        // Shift register for x pattern detection
        x_shift <= {x_shift[1:0], x};
        
        case (state)
            RESET: begin
                state <= PULSE_F;
                g <= 0;
            end
            
            PULSE_F: begin
                state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                if (pattern_match) begin
                    state <= MONITOR_Y;
                    g <= 1;  // Set g when entering MONITOR_Y
                    y_counter <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    state <= FINAL_HIGH;
                end else if (y_counter == 2) begin
                    state <= FINAL_LOW;
                end else begin
                    y_counter <= y_counter + 1;
                end
            end
            
            FINAL_HIGH: begin
                // Permanent state - no transitions out
                g <= 1;
            end
            
            FINAL_LOW: begin
                // Permanent state - no transitions out
                g <= 0;
            end
            
            default: state <= RESET;
        endcase
    end
end

endmodule