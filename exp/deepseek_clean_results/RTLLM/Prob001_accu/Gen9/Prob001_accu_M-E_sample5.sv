module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register to store 4 input values
    reg [7:0] data_buffer [0:3];
    reg [1:0] wr_ptr;
    reg buffer_full;
    
    // Pipeline registers
    reg [7:0] stage1 [0:3];
    reg [8:0] stage2 [0:1];
    reg [9:0] final_sum;
    
    // FSM states
    typedef enum logic [1:0] {IDLE, COLLECT, CALCULATE, OUTPUT} state_t;
    state_t current_state, next_state;
    
    // Clock gating
    wire shift_clk_en = valid_in && (current_state == COLLECT);
    wire shift_clk;
    
    clk_gate u_clk_gate (
        .clk_in(clk),
        .enable(shift_clk_en),
        .clk_out(shift_clk)
    );
    
    // FSM and data processing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            wr_ptr <= 0;
            buffer_full <= 0;
            valid_out <= 0;
            data_out <= 0;
            for (int i=0; i<4; i++) data_buffer[i] <= 0;
        end
        else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        wr_ptr <= 1;
                        data_buffer[0] <= data_in;
                    end
                end
                
                COLLECT: begin
                    if (valid_in) begin
                        if (wr_ptr == 3) begin
                            buffer_full <= 1;
                        end
                        data_buffer[wr_ptr] <= data_in;
                        wr_ptr <= wr_ptr + 1;
                    end
                end
                
                CALCULATE: begin
                    // Pipeline stage 1: register inputs
                    for (int i=0; i<4; i++) stage1[i] <= data_buffer[i];
                    
                    // Pipeline stage 2: parallel additions
                    stage2[0] <= stage1[0] + stage1[1];
                    stage2[1] <= stage1[2] + stage1[3];
                    
                    // Final sum
                    final_sum <= stage2[0] + stage2[1];
                end
                
                OUTPUT: begin
                    data_out <= final_sum;
                    valid_out <= 1;
                    buffer_full <= 0;
                    wr_ptr <= 0;
                end
            endcase
        end
    end
    
    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: if (valid_in) next_state = COLLECT;
            COLLECT: if (buffer_full) next_state = CALCULATE;
            CALCULATE: next_state = OUTPUT;
            OUTPUT: next_state = IDLE;
        endcase
    end
    
endmodule

// Clock gating cell
module clk_gate (
    input clk_in,
    input enable,
    output clk_out
);
    reg gated_clk;
    
    always @(*) begin
        if (!clk_in)
            gated_clk <= enable;
    end
    
    assign clk_out = gated_clk & clk_in;
endmodule