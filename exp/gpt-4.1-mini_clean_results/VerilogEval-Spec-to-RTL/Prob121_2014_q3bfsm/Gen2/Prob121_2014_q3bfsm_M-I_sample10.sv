module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    // One-hot encoded states: S0=00001, S1=00010, S2=00100, S3=01000, S4=10000
    localparam S0 = 5'b00001; // 000
    localparam S1 = 5'b00010; // 001
    localparam S2 = 5'b00100; // 010
    localparam S3 = 5'b01000; // 011
    localparam S4 = 5'b10000; // 100

    reg [4:0] state, next_state;

    always @(*) begin
        next_state = 5'b00000; // default invalid (for safety)
        z = 1'b0;
        case (state)
            S0: begin
                z = 1'b0;
                next_state = (x == 1'b0) ? S0 : S1;
            end
            S1: begin
                z = 1'b0;
                next_state = (x == 1'b0) ? S1 : S4;
            end
            S2: begin
                z = 1'b0;
                next_state = (x == 1'b0) ? S2 : S1;
            end
            S3: begin
                z = 1'b1;
                next_state = (x == 1'b0) ? S1 : S2;
            end
            S4: begin
                z = 1'b1;
                next_state = (x == 1'b0) ? S3 : S4;
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