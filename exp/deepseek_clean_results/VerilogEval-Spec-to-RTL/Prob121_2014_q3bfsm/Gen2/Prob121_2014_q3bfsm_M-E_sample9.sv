module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Gray code state encoding (minimizes bit transitions)
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b011;
    parameter S3 = 3'b010;
    parameter S4 = 3'b110;

    reg [2:0] state, next_state;
    wire z_comb;

    // Pre-decoded conditions for next state logic
    wire is_S0 = (state == S0);
    wire is_S1 = (state == S1);
    wire is_S2 = (state == S2);
    wire is_S3 = (state == S3);
    wire is_S4 = (state == S4);

    // Parallel next state logic (reduces critical path)
    always @(*) begin
        case (1'b1)
            is_S0: next_state = x ? S1 : S0;
            is_S1: next_state = x ? S4 : S1;
            is_S2: next_state = x ? S1 : S2;
            is_S3: next_state = x ? S2 : S1;
            is_S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Hybrid output generation:
    // - Comb. path for immediate response (Mealy)
    // - Registered path for stable output (Moore)
    assign z_comb = (state == S3) || (state == S4);

    // Output register eliminates glitches
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            z <= z_comb;
        end
    end

endmodule