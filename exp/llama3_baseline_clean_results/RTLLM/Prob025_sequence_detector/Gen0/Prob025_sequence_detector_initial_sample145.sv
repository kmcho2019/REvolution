module sequence_detector (
    input clk, 
    input reset_n, 
    input data_in, 
    output reg sequence_detected
);

reg [2:0] state; // 3 bits to represent 5 states: IDLE, S1, S2, S3, S4
parameter IDLE = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin // Reset behavior
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (state)
            IDLE: 
                if (data_in == 1'b1) begin
                    state <= S1;
                    sequence_detected <= 1'b0;
                end else begin
                    state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            S1: 
                if (data_in == 1'b0) begin
                    state <= S2;
                    sequence_detected <= 1'b0;
                end else begin
                    state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            S2: 
                if (data_in == 1'b0) begin
                    state <= S3;
                    sequence_detected <= 1'b0;
                end else begin
                    state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            S3: 
                if (data_in == 1'b1) begin
                    state <= S4;
                    sequence_detected <= 1'b0;
                end else begin
                    state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            S4: 
                if (data_in == 1'b1) begin
                    state <= IDLE;
                    sequence_detected <= 1'b1;
                end else begin
                    state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            default: state <= IDLE;
        endcase
    end
end

endmodule