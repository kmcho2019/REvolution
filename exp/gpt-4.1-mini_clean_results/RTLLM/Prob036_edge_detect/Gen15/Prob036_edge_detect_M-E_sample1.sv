module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // Output high for one clock cycle on rising edge of 'a'
    output reg  down    // Output high for one clock cycle on falling edge of 'a'
);

    // Synchronize input 'a' to clock domain using a 2-stage shift register to avoid metastability
    reg a_sync_0, a_sync_1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync_0 <= 1'b0;
            a_sync_1 <= 1'b0;
        end else begin
            a_sync_0 <= a;
            a_sync_1 <= a_sync_0;
        end
    end

    // State encoding for FSM
    typedef enum logic [1:0] {
        IDLE         = 2'd0,
        RISING_EDGE  = 2'd1,
        FALLING_EDGE = 2'd2
    } state_t;

    state_t curr_state, next_state;

    // Detect edges by comparing synchronized current and previous signals
    wire rising_edge  = (~a_sync_1) & a_sync_0;
    wire falling_edge = a_sync_1 & (~a_sync_0);

    // FSM sequential block: state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            curr_state <= IDLE;
        else
            curr_state <= next_state;
    end

    // FSM combinational block: next state logic and output generation
    always @(*) begin
        // Default outputs
        rise = 1'b0;
        down = 1'b0;
        next_state = curr_state;

        case (curr_state)
            IDLE: begin
                if (rising_edge) begin
                    next_state = RISING_EDGE;
                    rise = 1'b1;
                end else if (falling_edge) begin
                    next_state = FALLING_EDGE;
                    down = 1'b1;
                end
            end

            RISING_EDGE: begin
                // After asserting rise one cycle, return to IDLE
                next_state = IDLE;
                // Output is only asserted one cycle, so rise=0 here
            end

            FALLING_EDGE: begin
                // After asserting down one cycle, return to IDLE
                next_state = IDLE;
                // Output is only asserted one cycle, so down=0 here
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule