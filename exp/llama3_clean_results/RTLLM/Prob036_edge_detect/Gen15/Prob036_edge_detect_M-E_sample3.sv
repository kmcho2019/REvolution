module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg [1:0] state;  // FSM state register

// Define FSM states
localparam IDLE = 2'b00;
localparam EDGE_DETECT = 2'b01;

// Sequential logic for FSM and previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals and state to a known condition
        prev_a <= 1'b0;
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                prev_a <= a;
                if (a !== prev_a) begin
                    state <= EDGE_DETECT;
                end else begin
                    state <= IDLE;
                end
            end
            EDGE_DETECT: begin
                // Detect edge and set output signals
                if (a && !prev_a) begin
                    rise <= 1'b1;
                    down <= 1'b0;
                end else if (!a && prev_a) begin
                    rise <= 1'b0;
                    down <= 1'b1;
                end
                // Reset output signals after one clock cycle
                if (a === prev_a) begin
                    rise <= 1'b0;
                    down <= 1'b0;
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule