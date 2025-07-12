module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states - using 2 bits for 3 states
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        GOT1  = 2'b01,
        GOT10 = 2'b10
    } state_t;

    // State registers
    state_t current_state, next_state;
    reg z_comb;  // Combinational output

    // State transition logic (sequential)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
            z <= 0;
        end else begin
            current_state <= next_state;
            z <= z_comb;  // Register the output
        end
    end

    // Next state and output logic (combinational)
    always @(*) begin
        case (current_state)
            IDLE: begin
                z_comb = 0;
                next_state = x ? GOT1 : IDLE;
            end
            GOT1: begin
                z_comb = 0;
                next_state = x ? GOT1 : GOT10;
            end
            GOT10: begin
                z_comb = x;  // Output 1 only if we get '1' to complete '101'
                next_state = x ? GOT1 : IDLE;
            end
            default: begin
                z_comb = 0;
                next_state = IDLE;
            end
        endcase
    end

endmodule