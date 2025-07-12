module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] counter;
    reg [2:0] w_samples;
    wire window_complete = (counter == 2'b10);

    // Next state logic
    wire next_state;
    assign next_state = (state == A) ? (s ? B : A) : B;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 2'b0;
            w_samples <= 3'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update counter (modulo 3)
                counter <= window_complete ? 2'b0 : counter + 1'b1;
                
                // Shift in new w value
                w_samples <= {w_samples[1:0], w};
            end else begin
                // Reset tracking in state A
                counter <= 2'b0;
                w_samples <= 3'b0;
            end
        end
    end

    // Output logic - evaluate one cycle after window completes
    wire [1:0] sum = w_samples[0] + w_samples[1] + w_samples[2];
    assign z = (state == B) && (counter == 2'b0) && (sum == 2'd2);

endmodule