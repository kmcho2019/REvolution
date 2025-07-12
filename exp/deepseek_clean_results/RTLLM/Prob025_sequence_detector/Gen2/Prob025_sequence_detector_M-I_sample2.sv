module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// One-hot state encoding
localparam 
    IDLE = 4'b0001,
    S1   = 4'b0010,
    S2   = 4'b0100,
    S3   = 4'b1000;

reg [3:0] state;

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
                state <= data_in ? IDLE : IDLE;  // S4 not needed, detect immediately
                sequence_detected <= data_in;    // Assert when last '1' is seen
            end
            default: begin
                state <= IDLE;
                sequence_detected <= 1'b0;
            end
        endcase
    end
end

endmodule