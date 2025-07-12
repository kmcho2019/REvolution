module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot state encoding
    parameter [7:0] S0 = 8'b00000001;
    parameter [7:0] S1 = 8'b00000010;
    parameter [7:0] S2 = 8'b00000100;
    parameter [7:0] S3 = 8'b00001000;
    parameter [7:0] S4 = 8'b00010000;
    parameter [7:0] S5 = 8'b00100000;
    parameter [7:0] S6 = 8'b01000000;
    parameter [7:0] S7 = 8'b10000000;

    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // State transitions (parallel one-hot updates)
            state <= {1'b0, state[6:0]} & {8{in}};  // Shift left
            state[0] <= (~in) | (state == S0 && in); // S0 condition
            state[7] <= state[6] & in;              // S7 condition

            // Output generation (registered for correct timing)
            disc <= (state[5]) && !in;
            flag <= (state[6]) && !in;
            err <= (state[6] | state[7]) && in;
        end
    end

endmodule