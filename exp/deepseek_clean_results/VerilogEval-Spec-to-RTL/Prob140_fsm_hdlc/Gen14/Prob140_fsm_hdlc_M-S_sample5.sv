module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [2:0] state;

    // State definitions
    localparam S0 = 3'd0; // Initial state (0 consecutive 1s)
    localparam S1 = 3'd1; // 1 consecutive 1
    localparam S2 = 3'd2; // 2 consecutive 1s
    localparam S3 = 3'd3; // 3 consecutive 1s
    localparam S4 = 3'd4; // 4 consecutive 1s
    localparam S5 = 3'd5; // 5 consecutive 1s
    localparam S6 = 3'd6; // 6+ consecutive 1s (error state)

    // Output logic (combinational)
    assign disc = (state == S5) && !in;
    assign flag = (state == S6) && !in;
    assign err  = (state == S6) && in;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= in ? S1 : S0;
                S1: state <= in ? S2 : S0;
                S2: state <= in ? S3 : S0;
                S3: state <= in ? S4 : S0;
                S4: state <= in ? S5 : S0;
                S5: state <= in ? S6 : S0;
                S6: state <= in ? S6 : S0; // Stay in error until 0
                default: state <= S0;
            endcase
        end
    end

endmodule