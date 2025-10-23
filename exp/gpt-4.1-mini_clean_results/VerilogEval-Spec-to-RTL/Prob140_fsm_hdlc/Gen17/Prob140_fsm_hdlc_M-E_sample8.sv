module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot encoded states: each bit represents count of consecutive ones from 0 to 7+
    localparam [7:0]
        S0 = 8'b0000_0001, // 0 consecutive ones
        S1 = 8'b0000_0010, // 1 consecutive one
        S2 = 8'b0000_0100, // 2 consecutive ones
        S3 = 8'b0000_1000, // 3 consecutive ones
        S4 = 8'b0001_0000, // 4 consecutive ones
        S5 = 8'b0010_0000, // 5 consecutive ones
        S6 = 8'b0100_0000, // 6 consecutive ones
        S7 = 8'b1000_0000; // 7 or more consecutive ones (error)

    reg [7:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (1'b1) // one-hot encoded current state
            state[0]: begin // S0
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            state[1]: begin // S1
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            state[2]: begin // S2
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            state[3]: begin // S3
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            state[4]: begin // S4
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            state[5]: begin // S5
                if (in)
                    next_state = S6;
                else
                    next_state = S0;
            end
            state[6]: begin // S6
                if (in)
                    next_state = S7;
                else
                    next_state = S0;
            end
            state[7]: begin // S7 error state
                if (in)
                    next_state = S7;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Outputs combinational: detect disc, flag, err based on current state and input
    // disc: zero after five ones: state==S5 and input==0
    wire disc_int = (state == S5) && (in == 1'b0);
    // flag: zero after six ones: state==S6 and input==0
    wire flag_int = (state == S6) && (in == 1'b0);
    // err: next state is error (S7)
    wire err_int  = (next_state == S7);

    // Sequential logic: update state and register outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_int;
            flag  <= flag_int;
            err   <= err_int;
        end
    end

endmodule