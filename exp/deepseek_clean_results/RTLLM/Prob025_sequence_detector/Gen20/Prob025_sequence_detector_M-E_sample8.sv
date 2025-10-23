module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Circular buffer for last 4 bits
reg [3:0] history;
reg [1:0] ptr;  // Points to current position in sequence

// Sequence definition (1001)
parameter [3:0] TARGET = 4'b1001;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 4'b0;
        ptr <= 2'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        sequence_detected <= 1'b0;
        
        // Check if current input matches expected next bit
        if (data_in == TARGET[ptr]) begin
            history[ptr] <= data_in;
            
            // If we've matched all 4 bits
            if (ptr == 2'b11) begin
                sequence_detected <= 1'b1;
                ptr <= 2'b0;  // Reset for next sequence
            end
            else begin
                ptr <= ptr + 1;  // Advance to next bit
            end
        end
        else begin
            // Mismatch - reset pointer
            ptr <= 2'b0;
            
            // Special case: might be start of new sequence
            if (data_in == TARGET[0]) begin
                history[0] <= data_in;
                ptr <= 2'b1;
            end
        end
    end
end

endmodule