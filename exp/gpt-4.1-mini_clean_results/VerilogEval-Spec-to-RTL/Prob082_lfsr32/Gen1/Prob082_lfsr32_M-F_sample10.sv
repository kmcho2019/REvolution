module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Define tap positions as zero-based indices
    // taps at bits 32,22,2,1 (1-based) => q[31], q[21], q[1], q[0]
    wire feedback;

    integer i;
    reg [31:0] next_state;

    assign feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // MSB gets feedback
            next_state[31] = feedback;

            // For bits 30 down to 0
            for (i = 30; i >= 0; i = i - 1) begin
                // Check if i+1 is a tap bit (i+1 because next_state[i] depends on q[i+1])
                // taps are at bits 32,22,2,1 -> zero-based 31,21,1,0
                // So taps at i+1 == 31,21,1,0
                if ((i + 1) == 31 || (i + 1) == 21 || (i + 1) == 1 || (i + 1) == 0) begin
                    next_state[i] = q[i + 1] ^ feedback;
                end else begin
                    next_state[i] = q[i + 1];
                end
            end

            q <= next_state;
        end
    end

endmodule