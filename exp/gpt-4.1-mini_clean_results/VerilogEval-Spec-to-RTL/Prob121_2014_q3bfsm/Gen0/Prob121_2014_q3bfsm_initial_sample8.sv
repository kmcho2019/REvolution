module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state, next_state;

    // State encoding for clarity (optional)
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    // Next state and output logic
    always @(*) begin
        case(state)
            S0: begin
                if (x == 0)
                    next_state = S0;
                else
                    next_state = S1;
                z = 1'b0;
            end
            S1: begin
                if (x == 0)
                    next_state = S1;
                else
                    next_state = S4;
                z = 1'b0;
            end
            S2: begin
                if (x == 0)
                    next_state = S2;
                else
                    next_state = S1;
                z = 1'b0;
            end
            S3: begin
                if (x == 0)
                    next_state = S1;
                else
                    next_state = S2;
                z = 1'b1;
            end
            S4: begin
                if (x == 0)
                    next_state = S3;
                else
                    next_state = S4;
                z = 1'b1;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // State update on clock edge
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule