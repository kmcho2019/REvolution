module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] seq_cnt; // 4-bit sequence counter

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        seq_cnt <= 0; // Reset sequence counter
        start_shifting <= 0; // Reset start_shifting
    end else begin
        case (seq_cnt)
            4'd0: begin
                if (data == 1) begin
                    seq_cnt <= 4'd1; // Matched first bit
                end
            end
            4'd1: begin
                if (data == 1) begin
                    seq_cnt <= 4'd2; // Matched second bit
                end else begin
                    seq_cnt <= 4'd0; // Reset sequence counter
                end
            end
            4'd2: begin
                if (data == 0) begin
                    seq_cnt <= 4'd3; // Matched third bit
                end else begin
                    seq_cnt <= 4'd1; // Reset sequence counter to second bit
                end
            end
            4'd3: begin
                if (data == 1) begin
                    seq_cnt <= 4'd4; // Matched fourth bit
                    start_shifting <= 1; // Set start_shifting
                end else begin
                    seq_cnt <= 4'd0; // Reset sequence counter
                end
            end
            4'd4: begin
                start_shifting <= 1; // Keep start_shifting high
            end
            default: begin
                seq_cnt <= 4'd0; // Default state
            end
        endcase
    end
end

endmodule