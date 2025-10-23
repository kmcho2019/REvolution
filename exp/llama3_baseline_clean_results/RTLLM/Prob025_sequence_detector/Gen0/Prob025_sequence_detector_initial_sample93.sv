module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states
parameter IDLE = 4'b0000,
           S1   = 4'b0001,
           S2   = 4'b0010,
           S3   = 4'b0100,
           S4   = 4'b1000;

reg [3:0] current_state;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    current_state <= S4;
                    sequence_detected <= 1;
                end else begin
                    current_state <= IDLE;
                end
            end
            S4: begin
                sequence_detected <= 0;
                current_state <= IDLE;
            end
            default: current_state <= IDLE;
        endcase
    end
end

endmodule