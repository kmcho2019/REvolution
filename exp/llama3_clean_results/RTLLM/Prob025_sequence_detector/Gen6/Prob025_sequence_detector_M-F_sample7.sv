module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] state; // Changed to [2:0] to accommodate 5 states

localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100; // Added state for the fourth bit of the sequence

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    state <= S4;
                    sequence_detected <= 1'b1;
                end else begin
                    state <= IDLE;
                end
            end
            S4: begin
                state <= IDLE; // After detecting the sequence, return to IDLE
                sequence_detected <= 0; // Reset sequence_detected after one clock cycle
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule