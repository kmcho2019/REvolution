module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    parameter S0 = 3'b000;  // Initial state (0)
    parameter S1 = 3'b001;  // 1
    parameter S2 = 3'b010;  // 11
    parameter S3 = 3'b011;  // 111
    parameter S4 = 3'b100;  // 1111
    parameter S5 = 3'b101;  // 11111
    parameter S6 = 3'b110;  // 111111
    parameter S7 = 3'b111;  // 1111111+

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs (only set when conditions met)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions and output generation
            case (state)
                S0: state <= in ? S1 : S0;
                S1: state <= in ? S2 : S0;
                S2: state <= in ? S3 : S0;
                S3: state <= in ? S4 : S0;
                S4: state <= in ? S5 : S0;
                S5: begin
                    state <= in ? S6 : S0;
                    if (!in) disc <= 1;
                end
                S6: begin
                    state <= in ? S7 : S0;
                    if (!in) flag <= 1;
                end
                S7: begin
                    state <= in ? S7 : S0;
                    err <= 1;
                end
            endcase
        end
    end

endmodule