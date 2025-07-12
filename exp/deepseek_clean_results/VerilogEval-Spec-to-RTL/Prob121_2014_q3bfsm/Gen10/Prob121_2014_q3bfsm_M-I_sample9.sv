module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding parameters for readability
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    reg [2:0] state, next_state;
    reg next_z;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
        endcase
        next_z = (state == S3) || (state == S4);
    end

    // Sequential logic with state change detection
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end
        else begin
            if (state != next_state) begin
                state <= next_state;
            end
            z <= next_z;
        end
    end

endmodule