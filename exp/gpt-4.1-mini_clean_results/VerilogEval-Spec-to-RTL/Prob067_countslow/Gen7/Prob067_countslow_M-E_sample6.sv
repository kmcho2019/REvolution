module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    // Define states for counts 0 through 9
    typedef enum reg [3:0] {
        S0 = 4'd0,
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7,
        S8 = 4'd8,
        S9 = 4'd9
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        if (slowena) begin
            case (state)
                S0: next_state = S1;
                S1: next_state = S2;
                S2: next_state = S3;
                S3: next_state = S4;
                S4: next_state = S5;
                S5: next_state = S6;
                S6: next_state = S7;
                S7: next_state = S8;
                S8: next_state = S9;
                S9: next_state = S0;
                default: next_state = S0;
            endcase
        end else begin
            next_state = state; // Hold state if slowena low
        end
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(posedge clk) begin
        q <= state;
    end

endmodule