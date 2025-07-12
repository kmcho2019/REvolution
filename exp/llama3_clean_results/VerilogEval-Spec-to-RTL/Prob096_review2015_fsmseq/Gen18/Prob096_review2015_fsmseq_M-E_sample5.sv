module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] seq_counter; // Counter to track matching bits in the sequence
reg seq_detected; // Flag to indicate sequence detection

always @(posedge clk) begin
    if (reset) begin
        seq_counter <= 0; // Reset sequence counter
        seq_detected <= 0; // Reset sequence detection flag
        start_shifting <= 0; // Reset start_shifting
    end else begin
        if (seq_detected) begin
            start_shifting <= 1; // Set start_shifting if sequence detected
        end else begin
            case (seq_counter)
                0: begin
                    if (data == 1) begin
                        seq_counter <= 1; // Increment counter if '1' detected
                    end
                end
                1: begin
                    if (data == 1) begin
                        seq_counter <= 2; // Increment counter if '11' detected
                    end else begin
                        seq_counter <= 0; // Reset counter if '1' followed by '0'
                    end
                end
                2: begin
                    if (data == 0) begin
                        seq_counter <= 3; // Increment counter if '110' detected
                    end else begin
                        seq_counter <= 1; // Reset counter if '11' followed by '1'
                    end
                end
                3: begin
                    if (data == 1) begin
                        seq_detected <= 1; // Set sequence detection flag if sequence detected
                    end else begin
                        seq_counter <= 0; // Reset counter if '110' followed by '0'
                    end
                end
                default: begin
                    seq_counter <= 0; // Default counter value
                end
            endcase
        end
    end
end

endmodule