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
    reg [1:0] counter;     // 0-2 counter
    reg [2:0] w_samples;   // Stores last 3 w values
    wire window_boundary = (counter == 2'd0);

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Sum calculation (only at boundary)
    wire [1:0] sum = window_boundary ? (w_samples[0] + w_samples[1] + w_samples[2]) : 2'd0;

    // Output logic
    assign z = (state == B) && window_boundary && (sum == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 2'd0;
            w_samples <= 3'd0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update counter (modulo 3)
                counter <= (counter == 2'd2) ? 2'd0 : counter + 1'b1;
                
                // Shift in new w value only when needed
                if (counter != 2'd2) begin
                    w_samples <= {w_samples[1:0], w};
                end
            end else begin
                // Reset tracking in state A
                counter <= 2'd0;
                w_samples <= 3'd0;
            end
        end
    end

endmodule