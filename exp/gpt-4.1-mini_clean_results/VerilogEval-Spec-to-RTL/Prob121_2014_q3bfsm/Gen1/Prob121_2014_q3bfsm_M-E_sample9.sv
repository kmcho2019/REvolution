module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot encoded states (5 states)
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Combinational next state logic (one-hot)
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and registered output
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // output z is high only when state is S3 or S4
            z <= (next_state == S3) || (next_state == S4);
        end
    end

endmodule