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

    // Window tracking registers
    reg [1:0] counter;
    reg [2:0] w_samples;

    // State transition logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window evaluation signals
    wire window_complete = (counter == 2'd2);
    wire evaluate = (state == B) && (counter == 2'd0);
    wire [1:0] ones_count = w_samples[0] + w_samples[1] + w_samples[2];

    // Output assignment
    assign z = evaluate && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 2'd0;
            w_samples <= 3'd0;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update counter mod 3
                counter <= window_complete ? 2'd0 : counter + 1'd1;

                // Shift in new w value
                w_samples <= {w_samples[1:0], w};
            end else begin
                // Reset tracking in state A
                counter <= 2'd0;
                w_samples <= 3'd0;
            end
        end
    end

endmodule