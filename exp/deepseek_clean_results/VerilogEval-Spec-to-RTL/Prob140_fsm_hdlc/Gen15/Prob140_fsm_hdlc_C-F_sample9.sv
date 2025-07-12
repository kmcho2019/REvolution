module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Named states for clarity while maintaining counter efficiency
    parameter [2:0] S0 = 3'd0,
                   S1 = 3'd1,
                   S2 = 3'd2,
                   S3 = 3'd3,
                   S4 = 3'd4,
                   S5 = 3'd5,
                   S6 = 3'd6,
                   S7 = 3'd7;

    reg [2:0] state;
    wire next_err = (state >= S6) && in;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // State transitions
            if (in) begin
                if (state < S7) state <= state + 1;
            end else begin
                state <= S0;
            end

            // Output generation (registered)
            disc <= (state == S5) && !in;
            flag <= (state == S6) && !in;
            err <= next_err;
        end
    end

endmodule