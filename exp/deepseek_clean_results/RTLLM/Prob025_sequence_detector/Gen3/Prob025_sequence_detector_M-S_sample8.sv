module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Binary state encoding
localparam 
    IDLE = 2'b00,
    S1   = 2'b01,
    S2   = 2'b10,
    S3   = 2'b11;

reg [1:0] state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                state <= data_in ? S1 : IDLE;
                sequence_detected <= 1'b0;
            end
            S1: begin
                state <= data_in ? S1 : S2;
                sequence_detected <= 1'b0;
            end
            S2: begin
                state <= data_in ? S1 : S3;
                sequence_detected <= 1'b0;
            end
            S3: begin
                state <= data_in ? IDLE : IDLE;
                sequence_detected <= data_in;
            end
        endcase
    end
end

endmodule