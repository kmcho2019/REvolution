module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [1:0] state; // 2-bit state register
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
                if (data_in == 1'b1) begin
                    state <= S1;
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
                    state <= IDLE;
                    sequence_detected <= 1'b1; // Sequence detected, set output high
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state != S3 || data_in != 1'b1) begin
        sequence_detected <= 1'b0;
    end
end

endmodule