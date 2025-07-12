module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding: 5 states encoded in 5 bits
    // S0 = 5'b00001, S1 = 5'b00010, S2 = 5'b00100, S3 = 5'b01000, S4 = 5'b10000
    reg [4:0] state, next_state;

    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    always @(*) begin
        // Default next state to current state to avoid latches
        next_state = state;
        z = 1'b0;

        case (state)
            S0: begin
                z = 1'b0;
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                z = 1'b0;
                if (x)
                    next_state = S4;
                else
                    next_state = S1;
            end
            S2: begin
                z = 1'b0;
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
            end
            S3: begin
                z = 1'b1;
                if (x)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S4: begin
                z = 1'b1;
                if (x)
                    next_state = S4;
                else
                    next_state = S3;
            end
            default: begin
                z = 1'b0;
                next_state = S0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule