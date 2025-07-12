module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for storing last 4 inputs
    reg [7:0] data_buffer [0:3];
    reg [1:0] wr_ptr;
    
    // Pipelined adder registers
    reg [8:0] sum_stage1 [0:1];  // First addition stage (pair sums)
    reg [9:0] sum_stage2;        // Final sum
    
    // Control state machine
    typedef enum {IDLE, ACCUMULATING, OUTPUT} state_t;
    state_t current_state;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all registers
            for (integer i = 0; i < 4; i = i+1) data_buffer[i] <= 8'b0;
            wr_ptr <= 2'b0;
            sum_stage1[0] <= 9'b0;
            sum_stage1[1] <= 9'b0;
            sum_stage2 <= 10'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
            current_state <= IDLE;
        end else begin
            // Default outputs
            valid_out <= 1'b0;
            
            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        // Store first data and transition
                        data_buffer[0] <= data_in;
                        wr_ptr <= 2'b1;
                        current_state <= ACCUMULATING;
                    end
                end
                
                ACCUMULATING: begin
                    if (valid_in) begin
                        // Store new data
                        data_buffer[wr_ptr] <= data_in;
                        
                        // Update write pointer
                        if (wr_ptr == 2'b11) begin
                            wr_ptr <= 2'b0;
                            current_state <= OUTPUT;
                        end else begin
                            wr_ptr <= wr_ptr + 1;
                        end
                        
                        // Pipeline stage 1: Pair additions
                        if (wr_ptr[0]) begin
                            sum_stage1[0] <= data_buffer[0] + data_buffer[1];
                            if (wr_ptr == 2'b11) begin
                                sum_stage1[1] <= data_buffer[2] + data_in;
                            end
                        end
                    end
                end
                
                OUTPUT: begin
                    // Pipeline stage 2: Final sum
                    sum_stage2 <= sum_stage1[0] + sum_stage1[1];
                    
                    // Output results
                    data_out <= sum_stage2;
                    valid_out <= 1'b1;
                    
                    // Prepare for next cycle
                    if (valid_in) begin
                        data_buffer[0] <= data_in;
                        wr_ptr <= 2'b1;
                        current_state <= ACCUMULATING;
                    end else begin
                        current_state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule