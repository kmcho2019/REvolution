module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for last 4 inputs
    reg [7:0] data_buffer [0:3];
    reg [1:0] wr_ptr;
    
    // State machine
    typedef enum {IDLE, ACCUMULATING} state_t;
    state_t state;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize
            data_buffer[0] <= 8'b0;
            data_buffer[1] <= 8'b0;
            data_buffer[2] <= 8'b0;
            data_buffer[3] <= 8'b0;
            wr_ptr <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
            state <= IDLE;
        end else begin
            valid_out <= 1'b0;  // Default
            
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_buffer[0] <= data_in;
                        wr_ptr <= 2'b1;
                        state <= ACCUMULATING;
                    end
                end
                
                ACCUMULATING: begin
                    if (valid_in) begin
                        // Shift in new data
                        data_buffer[3] <= data_buffer[2];
                        data_buffer[2] <= data_buffer[1];
                        data_buffer[1] <= data_buffer[0];
                        data_buffer[0] <= data_in;
                        
                        // Update write pointer
                        wr_ptr <= wr_ptr + 1;
                        
                        // Check if we have 4 inputs
                        if (wr_ptr == 2'b11) begin
                            // Parallel addition of all 4 values
                            data_out <= data_buffer[0] + data_buffer[1] + 
                                       data_buffer[2] + data_buffer[3];
                            valid_out <= 1'b1;
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end

endmodule