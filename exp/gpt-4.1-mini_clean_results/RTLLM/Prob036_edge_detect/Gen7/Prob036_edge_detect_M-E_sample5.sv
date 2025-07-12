module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    typedef enum reg {LOW = 1'b0, HIGH = 1'b1} state_t;
    state_t state, next_state;

    // State update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= LOW;
        else
            state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        // Default outputs
        rise = 1'b0;
        down = 1'b0;
        next_state = state;

        case (state)
            LOW: begin
                if (a == 1'b1) begin
                    next_state = HIGH;
                    rise = 1'b1;  // Rising edge detected
                end
            end
            HIGH: begin
                if (a == 1'b0) begin
                    next_state = LOW;
                    down = 1'b1;  // Falling edge detected
                end
            end
        endcase
    end

endmodule