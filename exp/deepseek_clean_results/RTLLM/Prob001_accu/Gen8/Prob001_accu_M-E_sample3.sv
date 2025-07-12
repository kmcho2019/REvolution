module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for storing last 4 inputs
    reg [7:0] data_shift [0:3];
    reg [1:0] wr_ptr;
    reg full_flag;
    
    // Clock gating control
    wire shift_clk_en = valid_in & !full_flag;
    wire shift_clk = clk & shift_clk_en;
    
    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        COLLECTING,
        OUTPUT
    } state_t;
    
    state_t current_state, next_state;
    
    // Parallel adder wires
    wire [8:0] sum_stage1_0 = data_shift[0] + data_shift[1];
    wire [8:0] sum_stage1_1 = data_shift[2] + data_shift[3];
    wire [9:0] sum_final = sum_stage1_0 + sum_stage1_1;
    
    // Shift register update (clock gated)
    always @(posedge shift_clk or negedge rst_n) begin
        if (!rst_n) begin
            data_shift[0] <= 8'b0;
            data_shift[1] <= 8'b0;
            data_shift[2] <= 8'b0;
            data_shift[3] <= 8'b0;
            wr_ptr <= 2'b0;
        end
        else begin
            data_shift[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            full_flag <= (wr_ptr == 2'b11);
        end
    end
    
    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end
    
    // FSM next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = valid_in ? COLLECTING : IDLE;
            COLLECTING: next_state = full_flag ? OUTPUT : COLLECTING;
            OUTPUT: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= (current_state == OUTPUT);
            
            if (current_state == OUTPUT) begin
                data_out <= sum_final;
                // Clear shift register after output
                full_flag <= 1'b0;
                wr_ptr <= 2'b0;
            end
        end
    end

endmodule