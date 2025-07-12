module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Counting mechanisms - using Gray code for cycle_count
    reg [1:0] cycle_count;  // Modulo-3 counter (00->01->11->00)
    reg [1:0] ones_count;   // Count of 1's in current window
    reg next_z;             // Pre-computed output for next cycle

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            ones_count <= 2'b00;
            z <= 1'b0;
            next_z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
            
            if (state == B) begin
                // Update cycle counter with Gray code sequence
                case (cycle_count)
                    2'b00: cycle_count <= 2'b01;
                    2'b01: cycle_count <= 2'b11;
                    2'b11: cycle_count <= 2'b00;
                    default: cycle_count <= 2'b00;
                endcase
                
                // Update ones counter only when w changes
                if (cycle_count == 2'd0)
                    ones_count <= w;
                else if (w)
                    ones_count <= ones_count + 1'b1;
                
                // Pre-compute output condition when cycle_count=2
                if (cycle_count == 2'd1)
                    next_z <= (ones_count + w) == 2'd2;
                else
                    next_z <= 1'b0;
            end else begin
                // Reset counters in state A
                cycle_count <= 2'b00;
                ones_count <= 2'b00;
                next_z <= 1'b0;
            end
        end
    end

endmodule