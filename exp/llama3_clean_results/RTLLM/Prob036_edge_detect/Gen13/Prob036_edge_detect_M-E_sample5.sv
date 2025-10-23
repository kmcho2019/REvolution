module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] state;  // Current state of the FSM
reg prev_a;       // Previous state of the input signal 'a'

// Define the states of the FSM
localparam IDLE = 2'b00;
localparam RISE_DETECTED = 2'b01;
localparam FALL_DETECTED = 2'b10;

// Sequential logic to update the state and previous input signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state and previous input signal
        state <= IDLE;
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the previous input signal
        prev_a <= a;

        // Update the state based on the current state and input signal
        case (state)
            IDLE: begin
                if (a &&!prev_a) begin
                    state <= RISE_DETECTED;
                end else if (!a && prev_a) begin
                    state <= FALL_DETECTED;
                end else begin
                    state <= IDLE;
                end
            end
            RISE_DETECTED: begin
                rise <= 1'b1;
                state <= IDLE;
            end
            FALL_DETECTED: begin
                down <= 1'b1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase

        // Reset the output signals
        if (state == IDLE) begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end

endmodule