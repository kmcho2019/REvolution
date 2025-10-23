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

    // Window tracking
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [2:0] w_pattern;    // Stores last 3 w values

    // Next state logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Population count of w_pattern
    wire [1:0] pop_count = w_pattern[0] + w_pattern[1] + w_pattern[2];

    // Output logic (combinational)
    assign z = (state == B) && (cycle_count == 2'd0) && (pop_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_pattern <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update cycle counter
                cycle_count <= cycle_count + 1'b1;
                
                // Shift in new w value only when needed
                w_pattern <= {w_pattern[1:0], w};
            end else begin
                // Reset tracking in state A
                cycle_count <= 2'b00;
                w_pattern <= 3'b000;
            end
        end
    end

endmodule