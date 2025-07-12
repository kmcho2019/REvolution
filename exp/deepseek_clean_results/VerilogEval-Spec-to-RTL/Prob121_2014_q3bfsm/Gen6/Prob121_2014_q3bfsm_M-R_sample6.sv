module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State definitions with binary encoding
    parameter [2:0] S0 = 3'b000,
                   S1 = 3'b001,
                   S2 = 3'b010,
                   S3 = 3'b011,
                   S4 = 3'b100;

    reg [2:0] state, next_state;

    // Combinational next-state logic using case statement
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

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Registered output logic
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            z <= (state == S3) || (state == S4);
        end
    end

endmodule