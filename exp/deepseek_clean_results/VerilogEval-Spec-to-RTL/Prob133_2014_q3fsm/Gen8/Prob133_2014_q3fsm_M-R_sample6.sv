module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    // Window tracking
    reg [1:0] cycle_count;
    reg [2:0] w_samples;

    // Next state logic (combinational)
    wire next_state = (state == STATE_A) ? (s ? STATE_B : STATE_A) : STATE_B;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            cycle_count <= 2'b0;
            w_samples <= 3'b0;
        end else begin
            state <= next_state;
            
            if (state == STATE_B) begin
                // Update cycle counter (modulo 3)
                cycle_count <= (cycle_count == 2'b10) ? 2'b00 : (cycle_count + 1'b1);
                
                // Shift in new w value
                w_samples <= {w_samples[1:0], w};
            end else begin
                // Reset counters in state A
                cycle_count <= 2'b0;
                w_samples <= 3'b0;
            end
        end
    end

    // Output logic (combinational)
    wire [1:0] ones_count = w_samples[0] + w_samples[1] + w_samples[2];
    assign z = (state == STATE_B) && (cycle_count == 2'b00) ? (ones_count == 2'd2) : 1'b0;

endmodule