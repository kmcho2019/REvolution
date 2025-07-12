module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot encoding for 5 states
    localparam S0 = 5'b00001; // state 000
    localparam S1 = 5'b00010; // state 001
    localparam S2 = 5'b00100; // state 010
    localparam S3 = 5'b01000; // state 011
    localparam S4 = 5'b10000; // state 100

    reg [4:0] state, next_state;

    // Next state and output logic combinational
    always @(*) begin
        // default assignments
        next_state = S0;
        z = 1'b0;

        case (state)
            S0: begin
                next_state = x ? S1 : S0;
                z = 1'b0;
            end
            S1: begin
                next_state = x ? S4 : S1;
                z = 1'b0;
            end
            S2: begin
                next_state = x ? S1 : S2;
                z = 1'b0;
            end
            S3: begin
                next_state = x ? S2 : S1;
                z = 1'b1;
            end
            S4: begin
                next_state = x ? S4 : S3;
                z = 1'b1;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule