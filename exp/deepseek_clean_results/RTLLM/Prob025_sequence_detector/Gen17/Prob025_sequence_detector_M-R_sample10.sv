module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// State parameters
localparam IDLE = 1'b0;
localparam MATCHING = 1'b1;

reg [2:0] shift_reg;
reg state, next_state;
wire sequence_match;

// State transition logic
always @(*) begin
    case (state)
        IDLE: begin
            if (shift_reg[1:0] == 2'b10 && data_in == 1'b0)
                next_state = MATCHING;
            else
                next_state = IDLE;
        end
        
        MATCHING: begin
            if (data_in)
                next_state = IDLE;
            else if (shift_reg[1:0] != 2'b10)
                next_state = IDLE;
            else
                next_state = MATCHING;
        end
        
        default: next_state = IDLE;
    endcase
end

// Sequence detection logic
assign sequence_match = (state == MATCHING) && data_in;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        state <= IDLE;
    end
    else begin
        shift_reg <= {shift_reg[1:0], data_in};
        state <= next_state;
    end
end

// Output register
reg sequence_detected_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sequence_detected_reg <= 1'b0;
    else
        sequence_detected_reg <= sequence_match;
end

assign sequence_detected = sequence_detected_reg;

endmodule