module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] state; // 0: IDLE, 1: S1, 2: S2, 3: S3, not using 4 because only 4 states needed for this design
parameter IDLE = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (~data_in) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (~data_in) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (data_in) begin
                    state <= IDLE;
                    sequence_detected <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == S3 && data_in) begin
        sequence_detected <= 1;
    end else begin
        sequence_detected <= 0;
    end
end

endmodule