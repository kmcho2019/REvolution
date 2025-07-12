module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State parameters
localparam IDLE = 1'b0;
localparam MATCHING = 1'b1;

// Shift register and state variables
reg [3:0] shift_reg;
reg state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE: begin
            next_state = (shift_reg[2:0] == 3'b100 && data_in == 1'b1) ? MATCHING : IDLE;
        end
        
        MATCHING: begin
            next_state = (shift_reg[3:1] == 3'b100 && data_in == 1'b1) ? MATCHING : IDLE;
        end
        
        default: next_state = IDLE;
    endcase
end

// Output and shift register logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0;
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        state <= next_state;
        
        // Only update shift register when needed
        if (state != IDLE || data_in == 1'b1) begin
            shift_reg <= {shift_reg[2:0], data_in};
        end
        
        // Output is high when full pattern is matched
        sequence_detected <= (shift_reg == 4'b1001);
    end
end

endmodule