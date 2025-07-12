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
    reg [2:0] w_history;    // Shift register for w values

    // Next state logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic (combinational)
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = (state == B) && (cycle_count == 2'd0) && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_history <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update shift register
                w_history <= {w_history[1:0], w};
                
                // Modulo-3 counter
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
            end else begin
                // Reset counters in state A
                cycle_count <= 2'b00;
                w_history <= 3'b000;
            end
        end
    end

endmodule