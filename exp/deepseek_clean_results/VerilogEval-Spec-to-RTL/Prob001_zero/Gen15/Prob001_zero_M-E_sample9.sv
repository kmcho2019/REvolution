module TopModule (
    output zero
);

    // Internal free-running clock simulation
    reg clk = 0;
    always #5 clk = ~clk;

    // 2-bit counter
    reg [1:0] counter = 0;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    // State machine with 4 states
    reg [1:0] state = 0;
    always @(posedge clk) begin
        state <= (state == 2'b11) ? 2'b00 : state + 1;
    end

    // Multiple converging paths to zero
    wire path1_zero = (counter == 2'b00) & (state == 2'b00);
    wire path2_zero = (counter[0] ^ counter[1]) & (state[0] ^ state[1]);
    wire path3_zero = (counter > state) & (counter < state);
    wire path4_zero = |counter & ~|state;

    // Final output converges all paths to zero
    assign zero = path1_zero & path2_zero & path3_zero & path4_zero;

    // Force output to zero regardless of above logic
    initial begin
        force zero = 1'b0;
    end
endmodule