module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] state_buffer;
    reg [2:0] processing_window;
    reg [8:0] cell_counter;
    reg processing;
    
    // Double buffer for next state
    reg [511:0] next_state;
    
    // Processing state machine
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            state_buffer <= data;
            processing <= 0;
            cell_counter <= 0;
        end else begin
            if (!processing) begin
                // Start new processing cycle
                processing_window <= {state_buffer[0], state_buffer[0], 1'b0}; // Initialize with left boundary
                next_state <= state_buffer;
                processing <= 1;
                cell_counter <= 1;
            end else begin
                // Process 8 cells per cycle
                for (integer i = 0; i < 8; i = i + 1) begin
                    if (cell_counter <= 512) begin
                        // Update processing window
                        processing_window <= {state_buffer[cell_counter], 
                                           processing_window[1:0]};
                        
                        // Apply Rule 110
                        case (processing_window)
                            3'b111: next_state[cell_counter-1] <= 0;
                            3'b110: next_state[cell_counter-1] <= 1;
                            3'b101: next_state[cell_counter-1] <= 1;
                            3'b100: next_state[cell_counter-1] <= 0;
                            3'b011: next_state[cell_counter-1] <= 1;
                            3'b010: next_state[cell_counter-1] <= 1;
                            3'b001: next_state[cell_counter-1] <= 1;
                            3'b000: next_state[cell_counter-1] <= 0;
                        endcase
                        
                        cell_counter <= cell_counter + 1;
                    end
                end
                
                // Complete processing after 64 cycles (512 cells)
                if (cell_counter > 512) begin
                    q <= next_state;
                    state_buffer <= next_state;
                    processing <= 0;
                end
            end
        end
    end

endmodule