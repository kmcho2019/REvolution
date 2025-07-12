module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // One-hot state encoding
    reg [1:0] state;
    localparam A = 2'b01;
    localparam B = 2'b10;

    // State transition logic
    wire next_A = (state == A) ? ~s : 1'b0;
    wire next_B = (state == A) ? s : (state == B);

    // Window tracking
    reg [1:0] cycle_count;
    reg [2:0] w_samples;
    wire window_complete = (cycle_count == 2'b10);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b0;
            w_samples <= 3'b0;
        end else begin
            // State transition
            state <= {next_B, next_A};

            // Window tracking in state B
            if (state == B) begin
                cycle_count <= window_complete ? 2'b0 : (cycle_count + 1'b1);
                w_samples <= {w_samples[1:0], w};
            end else begin
                // Reset counters in state A
                cycle_count <= 2'b0;
                w_samples <= 3'b0;
            end
        end
    end

    // Output logic
    wire evaluate = (state == B) && (cycle_count == 2'b00);
    wire [1:0] count = w_samples[0] + w_samples[1] + w_samples[2];
    assign z = evaluate ? (count == 2'd2) : 1'b0;

endmodule