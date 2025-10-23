module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for the finite-state machine
localparam IDLE = 3'b000;
localparam FOUND1 = 3'b001;
localparam FOUND11 = 3'b010;
localparam FOUND110 = 3'b011;
localparam FOUND1101 = 3'b100;

reg [2:0] state; // Declare state as a 3-bit register

always @(posedge clk) begin
    if (reset) begin
        // Reset the state machine to IDLE and clear start_shifting
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                // If the input data is 1, transition to FOUND1; otherwise, stay in IDLE
                if (data) begin
                    state <= FOUND1;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND1: begin
                // If the input data is 1, transition to FOUND11; otherwise, reset to IDLE
                if (data) begin
                    state <= FOUND11;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND11: begin
                // If the input data is 0, transition to FOUND110; otherwise, reset to IDLE
                if (!data) begin
                    state <= FOUND110;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND110: begin
                // If the input data is 1, transition to FOUND1101; otherwise, reset to IDLE
                if (data) begin
                    state <= FOUND1101;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND1101: begin
                // Remain in this state and keep start_shifting = 1 until reset
                state <= FOUND1101;
            end
        endcase
        // Update start_shifting based on the current state
        if (state == FOUND1101) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule