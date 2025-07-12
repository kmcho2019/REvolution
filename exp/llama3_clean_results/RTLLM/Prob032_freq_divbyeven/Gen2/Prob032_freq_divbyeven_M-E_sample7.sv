module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Define the counter width based on the division factor
localparam CNT_WIDTH = $clog2(NUM_DIV);

// Counter register
reg [CNT_WIDTH-1:0] cnt;

// State machine registers
reg [1:0] state;
reg [1:0] next_state;

// State machine states
localparam IDLE = 2'b00;
localparam ACTIVE = 2'b01;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, state machine, and divided clock output on reset
        cnt <= 0;
        state <= IDLE;
        clk_div <= 0;
    end else begin
        // State machine logic
        case (state)
            IDLE: begin
                // If the counter is less than NUM_DIV - 1, increment it
                if (cnt < NUM_DIV - 1) begin
                    cnt <= cnt + 1;
                    next_state <= IDLE;
                end else begin
                    // If the counter reaches the limit, transition to the ACTIVE state
                    next_state <= ACTIVE;
                end
            end
            ACTIVE: begin
                // Toggle the divided clock output and reset the counter
                clk_div <= ~clk_div;
                cnt <= 0;
                next_state <= IDLE;
            end
            default: begin
                next_state <= IDLE;
            end
        endcase
        state <= next_state;
    end
end

endmodule