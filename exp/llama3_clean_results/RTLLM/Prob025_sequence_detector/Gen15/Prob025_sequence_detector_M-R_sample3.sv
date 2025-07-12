module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the sequence length
parameter SEQUENCE_LENGTH = 4;

// Define the expected sequence
parameter SEQUENCE = 4'b1001;

// Define the states
parameter IDLE = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg [1:0] state;

// Initialize the state machine and output on reset
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
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
                    state <= IDLE;
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

// Output generation
assign sequence_detected = (state == S3) && (data_in == 1'b1);

endmodule