module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
parameter IDLE = 1'b0;
parameter MATCHING = 1'b1;

reg state, next_state;
reg [1:0] shift_reg;

// State transition logic
always @(*) begin
    case (state)
        IDLE: begin
            if (shift_reg == 2'b10 && data_in == 1'b0)
                next_state = MATCHING;
            else
                next_state = IDLE;
        end
        
        MATCHING: begin
            if (data_in)
                next_state = IDLE;
            else if (shift_reg != 2'b10)
                next_state = IDLE;
            else
                next_state = MATCHING;
        end
    endcase
end

// Output logic
always @(*) begin
    sequence_detected = (state == MATCHING) && data_in;
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        shift_reg <= 2'b0;
    end
    else begin
        state <= next_state;
        shift_reg <= {shift_reg[0], data_in};
    end
end

endmodule