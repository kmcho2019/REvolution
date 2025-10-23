module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states
parameter IDLE = 4'b0000,
          S1 = 4'b0001,
          S2 = 4'b0010,
          S3 = 4'b0011,
          S4 = 4'b0100;

reg [3:0] current_state, next_state;
reg sequence_detected_reg;

always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S3;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
    endcase
end

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected_reg <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4 && data_in == 1'b1)
            sequence_detected_reg <= 1'b1;
        else
            sequence_detected_reg <= 1'b0;
    end
end

assign sequence_detected = sequence_detected_reg;

endmodule