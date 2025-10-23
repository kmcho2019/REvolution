module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

reg [1:0] current_state;
parameter IDLE = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        case (current_state)
            IDLE: if (data_in == 1'b1) begin
                       current_state <= S1;
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
                    current_state <= IDLE;
                end else begin
                    current_state <= IDLE;
                end
        endcase
    end
end

assign sequence_detected = (current_state == S3) && data_in;

endmodule