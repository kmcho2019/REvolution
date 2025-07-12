module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg [1:0] state;  // 2-bit register to store the current state
reg prev_a;       // Register to store the previous state of 'a'

// Define the states
localparam IDLE = 2'b00;
localparam RISE_DETECT = 2'b01;
localparam FALL_DETECT = 2'b10;

// Sequential logic to update the state and previous state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module
        state <= IDLE;
        prev_a <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (a &&!prev_a) begin
                    state <= RISE_DETECT;
                end else if (!a && prev_a) begin
                    state <= FALL_DETECT;
                end
            end
            RISE_DETECT: begin
                state <= IDLE;
            end
            FALL_DETECT: begin
                state <= IDLE;
            end
        endcase
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
    end
end

// Combinational logic for edge detection
assign rise = (state == RISE_DETECT);
assign down = (state == FALL_DETECT);

endmodule