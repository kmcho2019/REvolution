module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

    // Johnson counter has 2*N unique states (N=64 => 128 states)
    reg [6:0] step; // 7 bits to count up to 128

    integer i;

    // Generate the 64-bit Johnson pattern based on step
    // For step in [0..127]:
    // Q = { (step < 64) ? (step ones followed by zeros) : (64 - (step - 64) zeros followed by ones) }
    // Actually, Johnson sequence counts through patterns:
    // For step < 64: bits [63:63-step+1]=1, rest=0
    // For step >=64: bits [step-64]=0, rest=1 from lower bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            step <= 7'd0;
            Q    <= 64'b0;
        end else begin
            // increment step modulo 128
            step <= step + 7'd1;

            if (step < 7'd64) begin
                // For steps 0..63, upper bits set to 1, rest 0
                // Number of ones = step
                // MSB side ones:
                Q <= ({64{1'b1}} >> (64 - step));
            end else begin
                // For steps 64..127
                // pattern is complement of step-64 counting zeros on MSB side
                // number of zeros = step - 64
                // Ones fill the remaining lower bits
                Q <= ~({64{1'b1}} >> (step - 64));
            end
        end
    end

endmodule