module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Gray-coded state parameters for reduced switching power
    parameter S0 = 3'b000;  // 000
    parameter S1 = 3'b001;  // 001
    parameter S2 = 3'b011;  // 010 -> 011 (Gray)
    parameter S3 = 3'b010;  // 011 -> 010 (Gray)
    parameter S4 = 3'b110;  // 100 -> 110 (Gray)

    reg [2:0] state, next_state;

    // Split next-state logic for x=0 and x=1 cases
    wire [2:0] next_state_0 = (state == S0) ? S0 :
                             (state == S1) ? S1 :
                             (state == S2) ? S2 :
                             (state == S3) ? S1 : S3;

    wire [2:0] next_state_1 = (state == S0) ? S1 :
                             (state == S1) ? S4 :
                             (state == S2) ? S1 :
                             (state == S3) ? S2 : S4;

    // Early output calculation (parallel with state transition)
    always @(*) begin
        z = (state == S3) || (state == S4);
    end

    // State transition with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= x ? next_state_1 : next_state_0;
        end
    end

endmodule