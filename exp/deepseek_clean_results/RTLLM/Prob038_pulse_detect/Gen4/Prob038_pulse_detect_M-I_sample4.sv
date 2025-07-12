module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding using parameters
parameter [1:0] IDLE         = 2'b00;
parameter [1:0] GOT_0        = 2'b01;
parameter [1:0] GOT_01       = 2'b10;
parameter [1:0] PULSE_DETECT = 2'b11;

reg [1:0] current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    // Default assignments
    next_state = current_state;
    data_out = 1'b0;
    
    case (current_state)
        IDLE: begin
            if (!data_in) 
                next_state = GOT_0;
        end
        
        GOT_0: begin
            if (data_in) 
                next_state = GOT_01;
            // Stay in GOT_0 if we get consecutive 0s
        end
        
        GOT_01: begin
            if (!data_in) begin
                next_state = PULSE_DETECT;
                data_out = 1'b1;  // Pulse detected
            end else begin
                next_state = IDLE;  // Reset on 011 pattern
            end
        end
        
        PULSE_DETECT: begin
            // After detection, check for new 0
            next_state = (!data_in) ? GOT_0 : IDLE;
        end
    endcase
end

endmodule