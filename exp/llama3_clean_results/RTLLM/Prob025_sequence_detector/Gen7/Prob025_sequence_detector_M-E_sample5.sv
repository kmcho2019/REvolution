module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [1:0] state; // 2-bit state register for 4 states (IDLE, S1, S2, S3)
localparam IDLE = 2'b00;
localparam S1   = 2'b01;
localparam S2   = 2'b10;
localparam S3   = 2'b11;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin // start of sequence
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin // second bit of sequence
                    state <= S2;
                end else begin
                    state <= IDLE; // mismatch, reset to IDLE
                end
            end
            S2: begin
                if (data_in == 1'b0) begin // third bit of sequence
                    state <= S3;
                end else begin
                    state <= IDLE; // mismatch, reset to IDLE
                end
            end
            S3: begin
                if (data_in == 1'b1) begin // fourth bit of sequence
                    state <= IDLE;
                    sequence_detected <= 1'b1; // sequence detected
                end else begin
                    state <= IDLE; // mismatch, reset to IDLE
                    sequence_detected <= 1'b0;
                end
            end
        endcase
    end
end

endmodule