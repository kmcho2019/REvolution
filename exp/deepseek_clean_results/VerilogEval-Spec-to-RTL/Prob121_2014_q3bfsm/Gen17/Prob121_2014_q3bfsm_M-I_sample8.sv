module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Gray-coded state assignments to minimize transitions
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b011;
    parameter S3 = 3'b010;
    parameter S4 = 3'b110;

    reg [2:0] current_state, next_state;

    // State transition logic using case for better synthesis
    always @(*) begin
        case (current_state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // State register and output register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            // Registered output to improve timing
            z <= (next_state == S3) || (next_state == S4);
        end
    end

endmodule