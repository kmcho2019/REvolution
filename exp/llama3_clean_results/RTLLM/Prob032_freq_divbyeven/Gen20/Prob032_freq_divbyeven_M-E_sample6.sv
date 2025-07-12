// Novel state machine-based frequency divider module
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2!= 0) begin
        $fatal("NUM_DIV must be an even number.");
    end
end

// Calculate the required counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2((NUM_DIV / 2) + 1);  // Ensure sufficient width

// Define states for the state machine
enum logic [1:0] {IDLE, COUNTING, TOGGLE} state, next_state;

reg [CNT_WIDTH-1:0] cnt;  // Counter

// Sequential logic for state machine and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= '0;
        clk_div <= '0;
    end else begin
        case (state)
            IDLE: begin
                state <= COUNTING;
            end
            COUNTING: begin
                if (cnt == (NUM_DIV / 2 - 1)) begin
                    state <= TOGGLE;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            TOGGLE: begin
                cnt <= '0;
                clk_div <= ~clk_div;
                state <= COUNTING;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule