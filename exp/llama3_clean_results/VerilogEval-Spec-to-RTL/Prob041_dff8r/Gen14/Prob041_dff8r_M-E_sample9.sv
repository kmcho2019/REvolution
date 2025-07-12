module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

    logic [7:0] internal_reg;

    // Load data into internal register in parallel
    always_ff @(posedge clk) begin
        if (reset) begin
            internal_reg <= '0;
            q <= '0;
        end else begin
            internal_reg <= d;
            q <= internal_reg;
        end
    end

    // Optional: Add a control signal to synchronize data loading
    // logic load_control;
    // always_comb begin
    //     if (load_control) begin
    //         internal_reg <= d;
    //     end
    // end

endmodule