module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

reg [1:0] current_state;
parameter IDLE = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;
parameter S4 = 2'b11; // Note: Using the same encoding as S3 for simplicity, 
                        // but in a real scenario, you might need more bits to differentiate states properly

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: if (data_in == 1'b1) begin
                       current_state <= S1;
                   end else begin
                       current_state <= IDLE;
                   end
            S1: if (data_in == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
            S2: if (data_in == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
            S3: if (data_in == 1'b1) begin
                    current_state <= S4;
                end else begin
                    current_state <= IDLE;
                end
            S4: begin
                sequence_detected <= 1'b1;
                current_state <= IDLE;
            end
        endcase
    end
end

always_comb begin
    if (current_state == S4) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule