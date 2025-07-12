module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [2:0] current_state;
parameter IDLE = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
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
            default: current_state <= IDLE;
        endcase
    end
end

always_ff @(posedge clk) begin
    if (current_state != S4) begin
        sequence_detected <= 1'b0;
    end
end

endmodule