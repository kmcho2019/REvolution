module TopModule(clk, reset, s, w, z);
    input clk;
    input reset;
    input s;
    input w;
    output z;
    reg [1:0] counter; // Counter for clock cycles
    reg [1:0] w_count; // Counter for w high instances
    reg state_A; // Current state (1 for A, 0 for B)
    reg z_out; // Output z

    // Initialize state and counters
    initial begin
        state_A = 1'b1;
        counter = 2'd0;
        w_count = 2'd0;
        z_out = 1'b0;
    end

    // Sequential logic on positive edge of clock
    always @(posedge clk) begin
        if (reset) begin
            state_A <= 1'b1;
            counter <= 2'd0;
            w_count <= 2'd0;
            z_out <= 1'b0;
        end else begin
            if (state_A) begin // In state A
                if (s) begin
                    state_A <= 1'b0;
                    counter <= 2'd1;
                    w_count <= w ? 2'd1 : 2'd0;
                end
            end else begin // In state B
                if (counter < 2'd3) begin // Counting w instances
                    counter <= counter + 1'd1;
                    if (w) begin
                        w_count <= w_count + 1'd1;
                    end
                end else begin // Fourth cycle, decide z
                    z_out <= (w_count == 2'd2) ? 1'b1 : 1'b0;
                    counter <= 2'd1; // Reset counter for next window
                    w_count <= w ? 2'd1 : 2'd0; // Reset w_count
                end
            end
        end
    end

    // Continuous assignment for output z
    assign z = z_out;
endmodule