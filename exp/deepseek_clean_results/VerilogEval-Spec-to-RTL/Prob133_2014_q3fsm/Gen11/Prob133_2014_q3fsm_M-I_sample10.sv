module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Combined state encoding (3 bits: [state, cycle_count])
    reg [2:0] state;
    localparam STATE_A = 3'b000;
    localparam STATE_B0 = 3'b100; // B state, cycle 0
    localparam STATE_B1 = 3'b101; // B state, cycle 1
    localparam STATE_B2 = 3'b110; // B state, cycle 2

    // Window samples (only updated at cycle 2)
    reg [2:0] w_samples;

    // Next state logic (combinational)
    wire [2:0] next_state;
    assign next_state = (state == STATE_A) ? 
                       (s ? STATE_B0 : STATE_A) : 
                       (state == STATE_B2 ? STATE_B0 : state + 1'b1);

    // Specialized 2-of-3 detection logic
    wire two_ones;
    assign two_ones = ((w_samples[0] ^ w_samples[1] ^ w_samples[2]) & 
                      (w_samples[0] | w_samples[1] | w_samples[2])) == 1'b0;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_samples <= 3'b0;
        end else begin
            state <= next_state;
            
            // Only update samples at the end of each window (cycle 2)
            if (state == STATE_B2) begin
                w_samples <= {w_samples[1:0], w};
            end else if (state == STATE_A) begin
                w_samples <= 3'b0;
            end
        end
    end

    // Output logic (z asserted one cycle after window completes)
    assign z = (state == STATE_B0) ? two_ones : 1'b0;

endmodule