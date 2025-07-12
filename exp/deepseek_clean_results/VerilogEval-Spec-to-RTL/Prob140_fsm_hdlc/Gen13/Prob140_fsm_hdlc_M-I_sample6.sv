module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [1:0] count;  // Reduced to 2 bits (0-3)
    reg [2:0] state;  // One-hot for states 5,6,7 (bit 0:5, bit 1:6, bit 2:7)

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            state <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Update state tracking
            if (in) begin
                if (count < 3) count <= count + 1;  // Saturated count
                state <= {count == 3, count == 2, count == 1};  // One-hot for 5,6,7
            end else begin
                count <= 0;
                state <= 0;
            end

            // Output generation (only set when needed)
            if (in) begin
                err <= state[2];  // err when count would be 7
            end else begin
                disc <= state[0];  // disc after 5 ones
                flag <= state[1];  // flag after 6 ones
                err <= 0;         // clear err on zero
            end
        end
    end

endmodule