module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [1:0] state; // 2-bit state register for 4 states (IDLE, S1, S2, S3, S4)
localparam IDLE = 2'b00;
localparam S1   = 2'b01;
localparam S2   = 2'b10;
localparam S3   = 2'b11;

reg [3:0] shift_reg; // 4-bit shift register to store last 4 input bits

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {data_in, shift_reg[3:1]}; // shift in new input bit
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
                    state <= S4;
                end else begin
                    state <= IDLE; // mismatch, reset to IDLE
                end
            end
            S4: begin
                sequence_detected <= 1'b1; // sequence detected
                state <= IDLE;
            end
        endcase
    end
end

endmodule