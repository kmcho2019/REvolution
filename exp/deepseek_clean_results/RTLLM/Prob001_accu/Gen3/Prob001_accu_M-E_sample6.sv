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
    reg full_flag;
    
    // State machine
    typedef enum {IDLE, COLLECT, OUTPUT} state_t;
    state_t current_state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data_buffer[0] <= 8'b0;
            data_buffer[1] <= 8'b0;
            data_buffer[2] <= 8'b0;
            data_buffer[3] <= 8'b0;
            wr_ptr <= 2'b0;
            full_flag <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        data_buffer[0] <= data_in;
                        wr_ptr <= 2'b1;
                        next_state <= COLLECT;
                    end
                end
                
                COLLECT: begin
                    if (valid_in) begin
                        data_buffer[wr_ptr] <= data_in;
                        if (wr_ptr == 2'b11) begin
                            full_flag <= 1'b1;
                            next_state <= OUTPUT;
                        end
                        else begin
                            wr_ptr <= wr_ptr + 1'b1;
                        end
                    end
                end
                
                OUTPUT: begin
                    // Parallel addition of all 4 values
                    data_out <= {2'b0, data_buffer[0]} + 
                               {2'b0, data_buffer[1]} + 
                               {2'b0, data_buffer[2]} + 
                               {2'b0, data_buffer[3]};
                    valid_out <= 1'b1;
                    full_flag <= 1'b0;
                    wr_ptr <= 2'b0;
                    next_state <= IDLE;
                end
                
                default: next_state <= IDLE;
            endcase
        end
    end

endmodule