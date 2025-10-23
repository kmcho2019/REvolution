module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $fatal("NUM_DIV must be an even number.");
    end
end

// Calculate the required counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2(NUM_DIV);

reg [CNT_WIDTH-1:0] cnt;  // Counter
reg [1:0] state;         // Finite State Machine (FSM) states: IDLE (0), DIVIDE (1), RESET (2)

// FSM state transitions and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= '0;
        state <= 0;  // IDLE state
        clk_div <= '0;
    end else begin
        case (state)
            0: begin  // IDLE state
                if (cnt == (NUM_DIV / 2 - 1)) begin
                    state <= 1;  // Transition to DIVIDE state
                end else if (cnt == (NUM_DIV - 1)) begin
                    state <= 2;  // Transition to RESET state
                end else begin
                    cnt <= cnt + 1;
                end
            end
            1: begin  // DIVIDE state
                clk_div <= ~clk_div;  // Toggle divided clock output
                state <= 2;  // Transition to RESET state
            end
            2: begin  // RESET state
                cnt <= '0;
                state <= 0;  // Transition back to IDLE state
            end
        endcase
    end
end

endmodule