module TopModule (
    input clk,
    input d,
    output reg q
);

    reg d_sampled;
    reg ff_out;

    // Main flip-flop (positive edge triggered)
    always @(posedge clk) begin
        ff_out <= d;
    end

    // Negative edge sampling
    always @(negedge clk) begin
        d_sampled <= d;
    end

    // Output selection and latching
    always @(*) begin
        if (clk) begin
            q = ff_out;     // Positive edge phase
        end else begin
            q = d_sampled;  // Negative edge phase
        end
    end

endmodule