module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot encoded state parameters
    parameter S0 = 5'b00001;
    parameter S1 = 5'b00010;
    parameter S2 = 5'b00100;
    parameter S3 = 5'b01000;
    parameter S4 = 5'b10000;
    
    reg [4:0] state, next_state;
    wire state_changing = (state != next_state);
    wire gated_clk = clk & (reset | state_changing);

    always @(posedge gated_clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end
        else begin
            state <= next_state;
            z <= (next_state == S3) || (next_state == S4);
        end
    end

    always @(*) begin
        casez (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

endmodule