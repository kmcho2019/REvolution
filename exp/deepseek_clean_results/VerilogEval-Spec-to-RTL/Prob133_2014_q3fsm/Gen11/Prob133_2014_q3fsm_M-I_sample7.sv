module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Combined state encoding (3 bits)
    reg [2:0] state;
    localparam STATE_A = 3'b000;
    localparam STATE_B0 = 3'b001;  // First cycle of window
    localparam STATE_B1 = 3'b010;  // Second cycle
    localparam STATE_B2 = 3'b100;  // Third cycle

    // Window samples
    reg [1:0] w_samples;  // Only need to store 2 previous samples

    // Next state logic (combinational)
    wire [2:0] next_state;
    assign next_state = (state == STATE_A) ? 
                        (s ? STATE_B0 : STATE_A) :
                        (state == STATE_B0) ? STATE_B1 :
                        (state == STATE_B1) ? STATE_B2 : STATE_B0;

    // 2-of-3 detection logic (optimized)
    wire two_ones = (w & w_samples[0] & ~w_samples[1]) |  // w=1, sample0=1, sample1=0
                    (w & ~w_samples[0] & w_samples[1]) |  // w=1, sample0=0, sample1=1
                    (~w & w_samples[0] & w_samples[1]);   // w=0, sample0=1, sample1=1

    // Output logic (combinational)
    assign z = (state == STATE_B0) ? two_ones : 1'b0;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_samples <= 2'b0;
        end else begin
            state <= next_state;
            
            if (state == STATE_B0 || state == STATE_B1) begin
                // Only sample w when needed (B0 and B1 states)
                w_samples <= {w_samples[0], w};
            end
        end
    end

endmodule