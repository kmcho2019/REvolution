module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_reg;
reg [1:0] match_count;
reg seq_detected;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
        match_count <= 2'b00;
        seq_detected <= 0;
        start_shifting <= 0;
    end else begin
        shift_reg <= {shift_reg[2:0], data};
        
        // Check for sequence match from left to right
        if (shift_reg[3] == 1) begin // First bit of sequence
            match_count <= 2'b01;
        end else if (match_count == 2'b01 && shift_reg[2] == 1) begin // Second bit
            match_count <= 2'b10;
        end else if (match_count == 2'b10 && shift_reg[1] == 0) begin // Third bit
            match_count <= 2'b11;
        end else if (match_count == 2'b11 && shift_reg[0] == 1) begin // Fourth bit
            seq_detected <= 1;
        end else begin
            match_count <= 2'b00;
        end
        
        // Set start_shifting based on sequence detection and reset
        if (seq_detected) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule