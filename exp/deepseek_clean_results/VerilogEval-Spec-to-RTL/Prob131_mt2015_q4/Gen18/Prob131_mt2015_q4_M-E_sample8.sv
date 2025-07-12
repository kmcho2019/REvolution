module TopModule(
    input clk,
    input x,
    input y,
    output reg z
);
    // State definitions
    typedef enum {IDLE, COMPUTE} state_t;
    state_t current_state, next_state;
    
    // Computation registers
    reg a_result, b_result;
    reg computation_done;
    
    // State machine
    always @(posedge clk) begin
        current_state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case(current_state)
            IDLE: next_state = (x || y) ? COMPUTE : IDLE;
            COMPUTE: next_state = computation_done ? IDLE : COMPUTE;
            default: next_state = IDLE;
        endcase
    end
    
    // Computation logic
    always @(posedge clk) begin
        if (current_state == COMPUTE) begin
            if (!computation_done) begin
                // Time slot 1: Compute ModuleA function
                a_result <= x & ~y;
                // Time slot 2: Compute ModuleB function
                b_result <= ~(x ^ y);
                computation_done <= 1'b1;
            end
        end else begin
            computation_done <= 1'b0;
        end
    end
    
    // Output logic
    always @(posedge clk) begin
        if (computation_done) begin
            z <= a_result ^ b_result;
        end
    end
endmodule