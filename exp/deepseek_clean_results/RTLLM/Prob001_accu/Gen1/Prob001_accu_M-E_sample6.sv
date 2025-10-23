module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for storing inputs
    reg [7:0] data_buffer [0:3];
    reg [2:0] count;
    reg gated_clk;

    // Clock gating for power optimization
    always @(*) begin
        gated_clk = clk & (valid_in | !rst_n);
    end

    // State machine states
    typedef enum {IDLE, COLLECT, OUTPUT} state_t;
    state_t current_state, next_state;

    // State machine and shift register
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            count <= 3'b0;
            for (int i=0; i<4; i=i+1) begin
                data_buffer[i] <= 8'b0;
            end
        end
        else begin
            current_state <= next_state;
            
            if (valid_in) begin
                // Shift in new data
                data_buffer[3] <= data_buffer[2];
                data_buffer[2] <= data_buffer[1];
                data_buffer[1] <= data_buffer[0];
                data_buffer[0] <= data_in;
                
                if (count < 3'd3) begin
                    count <= count + 1'b1;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        valid_out = 1'b0;
        data_out = 10'b0;

        case (current_state)
            IDLE: begin
                if (valid_in) next_state = COLLECT;
            end
            
            COLLECT: begin
                if (count == 3'd3) begin
                    next_state = OUTPUT;
                end
            end
            
            OUTPUT: begin
                // Parallel addition of all 4 values
                data_out = data_buffer[0] + data_buffer[1] + 
                          data_buffer[2] + data_buffer[3];
                valid_out = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

endmodule