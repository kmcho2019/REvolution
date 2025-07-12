module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum reg [3:0] {
        S0  = 4'd0,  // 0 consecutive ones
        S1  = 4'd1,  // 1 consecutive one
        S2  = 4'd2,  // 2 consecutive ones
        S3  = 4'd3,  // 3 consecutive ones
        S4  = 4'd4,  // 4 consecutive ones
        S5  = 4'd5,  // 5 consecutive ones
        S6  = 4'd6,  // 6 consecutive ones
        S7  = 4'd7   // 7 or more consecutive ones (error)
    } state_t;

    reg [3:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;  // saturate at error
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and outputs (Moore)
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Moore outputs depend on current state (one cycle after detection)
            disc <= (state == S5) && (in == 1'b0); // zero after 5 ones detected previous cycle
            flag <= (state == S6) && (in == 1'b0); // zero after 6 ones detected previous cycle
            err  <= (state == S7) || ((state == S6) && in); // error on 7 or more ones or input 1 on 6 ones
        end
    end

endmodule