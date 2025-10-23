module sequence_detector(
    input           clk,
    input           reset_n, // Renamed from rst_n to reset_n for consistency
    input           data_in,
    output reg      sequence_detected
);

// Define states with explicit names for clarity
localparam IDLE = 4'b0000;
localparam S1   = 4'b0001;
localparam S2   = 4'b0010;
localparam S3   = 4'b0011;
localparam S4   = 4'b0100;

reg [3:0] state; // Use 4-bit state register to explicitly encode all states
reg [3:0] next_state;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
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
                    sequence_detected <= 1'b1; // Sequence detected, set output high
                end else begin
                    state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            end
            S4: begin
                // After detecting the sequence, reset to IDLE
                state <= IDLE;
                sequence_detected <= 1'b0; // Reset output after one clock cycle
            end
        endcase
    end
end

endmodule