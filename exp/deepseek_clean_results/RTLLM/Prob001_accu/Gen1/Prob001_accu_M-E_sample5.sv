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
    
    // Pipeline registers for adder tree
    reg [8:0] sum_01, sum_23;
    reg [9:0] final_sum;
    
    // State machine
    typedef enum {IDLE, ACCUMULATING} state_t;
    state_t state;
    
    integer i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all registers
            for (i = 0; i < 4; i = i + 1)
                data_buffer[i] <= 8'b0;
            wr_ptr <= 2'b0;
            sum_01 <= 9'b0;
            sum_23 <= 9'b0;
            final_sum <= 10'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
            state <= IDLE;
        end else begin
            valid_out <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        // Store first data and move to accumulating
                        data_buffer[0] <= data_in;
                        wr_ptr <= 2'b1;
                        state <= ACCUMULATING;
                    end
                end
                
                ACCUMULATING: begin
                    if (valid_in) begin
                        // Store new data in circular buffer
                        data_buffer[wr_ptr] <= data_in;
                        wr_ptr <= wr_ptr + 1;
                        
                        // Pipeline stage 1: add pairs
                        sum_01 <= data_buffer[0] + data_buffer[1];
                        sum_23 <= data_buffer[2] + data_buffer[3];
                        
                        // Pipeline stage 2: final sum
                        if (wr_ptr == 2'b11) begin
                            final_sum <= sum_01 + sum_23;
                            valid_out <= 1'b1;
                            data_out <= sum_01 + sum_23;
                        end
                    end
                end
            endcase
        end
    end

endmodule