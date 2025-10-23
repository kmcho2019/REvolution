module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for storing last 4 inputs
    reg [7:0] data_reg [0:3];
    reg [1:0] wr_ptr;
    
    // State machine
    typedef enum {IDLE, COLLECT, OUTPUT} state_t;
    state_t current_state, next_state;
    
    // Parallel adder signals
    wire [8:0] sum01 = data_reg[0] + data_reg[1];
    wire [8:0] sum23 = data_reg[2] + data_reg[3];
    wire [9:0] total_sum = sum01 + sum23;

    // State machine and data path
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            wr_ptr <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
            for (int i=0; i<4; i=i+1) data_reg[i] <= 8'b0;
        end else begin
            current_state <= next_state;
            valid_out <= 1'b0;
            
            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        data_reg[0] <= data_in;
                        wr_ptr <= 2'b1;
                        next_state <= COLLECT;
                    end
                end
                
                COLLECT: begin
                    if (valid_in) begin
                        data_reg[wr_ptr] <= data_in;
                        if (wr_ptr == 2'b11) begin
                            next_state <= OUTPUT;
                        end else begin
                            wr_ptr <= wr_ptr + 1'b1;
                        end
                    end
                end
                
                OUTPUT: begin
                    data_out <= total_sum;
                    valid_out <= 1'b1;
                    next_state <= IDLE;
                end
            endcase
        end
    end

endmodule