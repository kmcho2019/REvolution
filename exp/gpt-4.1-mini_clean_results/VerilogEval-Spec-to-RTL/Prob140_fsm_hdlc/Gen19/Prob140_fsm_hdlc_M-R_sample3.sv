module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum reg [3:0] {
        S0 = 4'd0, // zero consecutive ones
        S1 = 4'd1, // 1 one
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7, // saturated 7 or more ones
        S8 = 4'd8  // error state: more than 7 ones (optional, here lumped into S7)
    } state_t;

    state_t curr_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            curr_state <= S0;
        end else begin
            curr_state <= next_state;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (curr_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // stay in saturated error state if more ones
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore outputs) registered with state
    // The outputs disc, flag, err are asserted one cycle after detecting the pattern
    // Detect disc: sequence 0111110 => after seeing 5 ones then a zero (state S5 and input=0)
    // Detect flag: sequence 01111110 => after seeing 6 ones then a zero (state S6 and input=0)
    // Detect err: sequence 01111111... => seeing 7 or more ones (state S7 and input=1)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= (curr_state == S5) && (in == 1'b0);
            flag <= (curr_state == S6) && (in == 1'b0);
            err  <= (curr_state == S7) && (in == 1'b1);
        end
    end

endmodule