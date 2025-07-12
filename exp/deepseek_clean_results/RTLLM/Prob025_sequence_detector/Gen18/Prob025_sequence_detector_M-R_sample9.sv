module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

localparam IDLE = 1'b0;
localparam MATCHING = 1'b1;

reg state, next_state;
reg [1:0] shift_reg;
wire sequence_detected_w;

// State register
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

// Next state and output logic
always @(*) begin
    next_state = state;
    sequence_detected_w = 1'b0;
    
    case (state)
        IDLE: begin
            if (shift_reg == 2'b10 && data_in == 1'b0)
                next_state = MATCHING;
        end
        
        MATCHING: begin
            if (data_in) begin
                sequence_detected_w = 1'b1;
                next_state = IDLE;
            end
            else if (shift_reg != 2'b10) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Output register
reg sequence_detected_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sequence_detected_reg <= 1'b0;
    else
        sequence_detected_reg <= sequence_detected_w;
end

assign sequence_detected = sequence_detected_reg;

endmodule