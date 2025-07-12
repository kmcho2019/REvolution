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
    reg [1:0] cycle_count;  // Tracks 0-2 cycles
    reg [1:0] w_counter;    // Tracks net 1's (0-3)

    // State transition
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic - check counter at window boundary
    assign z = (state == B) && (cycle_count == 2'd2) && (w_counter == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_counter <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update cycle counter (modulo 3)
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                
                // Update w counter with saturation
                if (w) begin
                    if (w_counter < 2'd3) w_counter <= w_counter + 1'b1;
                end else begin
                    if (w_counter > 2'd0) w_counter <= w_counter - 1'b1;
                end
                
                // Reset counter at window boundary
                if (cycle_count == 2'd2) w_counter <= 2'b00;
            end else begin
                // Reset tracking in state A
                cycle_count <= 2'b00;
                w_counter <= 2'b00;
            end
        end
    end

endmodule