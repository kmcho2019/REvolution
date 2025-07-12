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
    reg [8:0] sum_01;
    reg [8:0] sum_23;
    
    // State machine
    typedef enum {IDLE, ACCUMULATING, OUTPUT} state_t;
    state_t state;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all registers
            wr_ptr <= 0;
            sum_01 <= 0;
            sum_23 <= 0;
            valid_out <= 0;
            data_out <= 0;
            state <= IDLE;
            for (int i=0; i<4; i=i+1) data_buffer[i] <= 0;
        end else begin
            valid_out <= 0;  // Default output
            
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_buffer[wr_ptr] <= data_in;
                        wr_ptr <= wr_ptr + 1;
                        state <= ACCUMULATING;
                    end
                end
                
                ACCUMULATING: begin
                    if (valid_in) begin
                        data_buffer[wr_ptr] <= data_in;
                        wr_ptr <= wr_ptr + 1;
                        
                        // Pipelined additions
                        sum_01 <= data_buffer[0] + data_buffer[1];
                        sum_23 <= data_buffer[2] + data_buffer[3];
                        
                        if (wr_ptr == 2'b11) begin
                            state <= OUTPUT;
                        end
                    end
                end
                
                OUTPUT: begin
                    // Final addition of partial sums
                    data_out <= sum_01 + sum_23;
                    valid_out <= 1;
                    wr_ptr <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule