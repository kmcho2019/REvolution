module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;

    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    // Combinational next state logic as a function of state and x
    wire [2:0] next_state = (state == S0) ? (x ? S1 : S0) :
                           (state == S1) ? (x ? S4 : S1) :
                           (state == S2) ? (x ? S1 : S2) :
                           (state == S3) ? (x ? S2 : S1) :
                           (state == S4) ? (x ? S4 : S3) :
                           S0;

    // Combinational output logic derived from current state
    wire z_comb = (state == S3) || (state == S4);

    // Synchronous state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output registered separately for timing clarity
    always @(posedge clk) begin
        z <= z_comb;
    end

endmodule