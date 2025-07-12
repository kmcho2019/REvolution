module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding using counter
    parameter [2:0] S0 = 3'b000;
    parameter [2:0] S1 = 3'b001;
    parameter [2:0] S2 = 3'b010;
    parameter [2:0] S3 = 3'b011;
    parameter [2:0] S4 = 3'b100;
    parameter [2:0] S5 = 3'b101;
    parameter [2:0] S6 = 3'b110;
    parameter [2:0] S7 = 3'b111;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // State transition with conditional update
            if (in) begin
                if (state < S7) state <= state + 1;
            end else begin
                state <= S0;
            end

            // Output generation (registered for correct timing)
            disc <= (state == S5) && !in;
            flag <= (state == S6) && !in;
            err <= (state >= S6) && in;
        end
    end

endmodule