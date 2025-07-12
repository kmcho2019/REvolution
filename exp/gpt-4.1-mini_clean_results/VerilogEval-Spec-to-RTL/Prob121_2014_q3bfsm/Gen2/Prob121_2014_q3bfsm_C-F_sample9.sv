module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state, next_state;
    reg next_z;

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (x == 1'b0) ? S0 : S1;
            S1: next_state = (x == 1'b0) ? S1 : S4;
            S2: next_state = (x == 1'b0) ? S2 : S1;
            S3: next_state = (x == 1'b0) ? S1 : S2;
            S4: next_state = (x == 1'b0) ? S3 : S4;
            default: next_state = S0;
        endcase
    end

    // Output combinational logic based only on current state
    always @(*) begin
        case(state)
            S3: next_z = 1'b1;
            S4: next_z = 1'b1;
            default: next_z = 1'b0;
        endcase
    end

    // Sequential block for state and registered output z
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule