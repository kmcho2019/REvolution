module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Combined state and counter encoding
    reg [2:0] state;
    localparam STATE_A = 3'b000;
    localparam STATE_B0 = 3'b001;  // First cycle in B
    localparam STATE_B1 = 3'b010;  // Second cycle in B
    localparam STATE_B2 = 3'b100;  // Third cycle in B (output evaluation)

    // Window samples (only need to store last 2 bits)
    reg [1:0] w_samples;

    // Next state logic (combinational)
    wire [2:0] next_state;
    assign next_state = reset ? STATE_A :
                      (state == STATE_A) ? (s ? STATE_B0 : STATE_A) :
                      {state[1:0], state[2]};  // Johnson counter rotation

    // Sequential logic
    always @(posedge clk) begin
        state <= next_state;
        
        // Update w_samples only when needed (B0 and B1 states)
        if (next_state[0] || next_state[1]) begin
            w_samples <= {w_samples[0], w};
        end
    end

    // Optimized 2-of-3 detector (w_samples[1:0] and current w)
    wire exactly_two_ones = 
        (w_samples[1] & w_samples[0] & ~w) |
        (w_samples[1] & ~w_samples[0] & w) |
        (~w_samples[1] & w_samples[0] & w);

    // Output logic - only active in STATE_B2
    assign z = (state == STATE_B2) ? exactly_two_ones : 1'b0;

endmodule