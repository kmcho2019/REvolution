module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Combined counter register [cycle_count, ones_count]
    reg [2:0] counters;  // [1:0] cycle_count, [2] ones_count MSB
    wire [1:0] cycle_count = counters[1:0];
    wire [1:0] ones_count = {counters[2], w};  // Pipelined counting

    // State transition logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic (combinational) - evaluate only at window boundary
    assign z = (state == B) && (cycle_count == 2'd2) && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counters <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Optimized modulo-3 counter with simpler increment
                counters[1:0] <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                
                // Pipelined ones counting:
                // Stage 1: Store MSB of count from previous cycle
                // Stage 2: Combine with current w for full count
                if (cycle_count == 2'd0) begin
                    counters[2] <= w;  // Start new window
                end else if (cycle_count == 2'd1) begin
                    counters[2] <= counters[2] + w;  // Intermediate count
                end
            end else begin
                // Reset counters when in state A
                counters <= 3'b000;
            end
        end
    end

endmodule