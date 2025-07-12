module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Shift register for last 3 bytes
    reg [7:0] byte_shift [2:0];
    
    // Pipeline stages for message validity
    reg [2:0] valid_pipe;
    
    // Boundary detection signal
    wire boundary_detected = in[3];
    
    always @(posedge clk) begin
        if (reset) begin
            // Clear shift register
            byte_shift[0] <= 8'b0;
            byte_shift[1] <= 8'b0;
            byte_shift[2] <= 8'b0;
            
            // Clear validity pipeline
            valid_pipe <= 3'b0;
            
            // Clear outputs
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_shift[2] <= byte_shift[1];
            byte_shift[1] <= byte_shift[0];
            byte_shift[0] <= in;
            
            // Update validity pipeline
            valid_pipe <= {valid_pipe[1:0], boundary_detected};
            
            // Check if we have 3 valid bytes
            if (valid_pipe == 3'b111) begin
                out_bytes <= {byte_shift[2], byte_shift[1], byte_shift[0]};
                done <= 1'b1;
                
                // Reset pipeline for next message
                valid_pipe <= 3'b0;
            end else begin
                done <= 1'b0;
            end
            
            // Special case: new boundary detected while collecting
            if (boundary_detected && !valid_pipe[0]) begin
                valid_pipe <= 3'b001;
            end
        end
    end

endmodule