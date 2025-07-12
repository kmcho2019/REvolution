module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Internal shift registers and processing state
    reg [63:0] processing_window;
    reg [2:0] phase_counter;
    reg [5:0] chunk_counter;
    reg [511:0] next_q_buffer;
    
    // Boundary handling registers
    reg left_boundary, right_boundary;
    
    // Processing state machine
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            phase_counter <= 0;
            chunk_counter <= 0;
        end else begin
            case (phase_counter)
                0: begin // Load processing window
                    processing_window <= q[63:0];
                    left_boundary <= 0;
                    right_boundary <= q[64];
                    chunk_counter <= 1;
                    phase_counter <= 1;
                end
                1,2,3,4,5,6,7: begin // Process current window
                    // Process 8 bits per cycle (pipelined)
                    for (integer i = 0; i < 8; i = i+1) begin
                        integer idx = phase_counter*8 + i;
                        if (idx < 64) begin
                            wire left = (idx == 63) ? right_boundary : processing_window[idx+1];
                            wire center = processing_window[idx];
                            wire right = (idx == 0) ? left_boundary : processing_window[idx-1];
                            
                            // Optimized Rule 110 logic
                            next_q_buffer[(chunk_counter-1)*64 + idx] <= 
                                (left & center & ~right) | 
                                (left & ~center & right) | 
                                (~left & center) | 
                                (~left & right);
                        end
                    end
                    
                    if (phase_counter == 7) begin
                        if (chunk_counter == 8) begin
                            phase_counter <= 0;
                            q <= next_q_buffer;
                        end else begin
                            // Shift to next chunk
                            processing_window <= q[(chunk_counter+1)*64-1 -: 64];
                            left_boundary <= q[chunk_counter*64-1];
                            right_boundary <= (chunk_counter == 7) ? 0 : q[(chunk_counter+1)*64];
                            chunk_counter <= chunk_counter + 1;
                            phase_counter <= 1;
                        end
                    end else begin
                        phase_counter <= phase_counter + 1;
                    end
                end
            endcase
        end
    end

endmodule