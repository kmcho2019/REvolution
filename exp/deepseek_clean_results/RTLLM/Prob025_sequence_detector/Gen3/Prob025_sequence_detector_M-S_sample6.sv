module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Binary state encoding
parameter [1:0] IDLE   = 2'b00;
parameter [1:0] S1     = 2'b01;
parameter [1:0] S2     = 2'b10;
parameter [1:0] S3     = 2'b11;

reg [1:0] state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        sequence_detected <= 1'b0; // Default output
        
        case (state)
            IDLE: begin
                if (data_in) state <= S1;
            end
            S1: begin
                if (!data_in) state <= S2;
                else state <= S1;
            end
            S2: begin
                if (!data_in) state <= S3;
                else state <= S1;
            end
            S3: begin
                if (data_in) begin
                    sequence_detected <= 1'b1;
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule