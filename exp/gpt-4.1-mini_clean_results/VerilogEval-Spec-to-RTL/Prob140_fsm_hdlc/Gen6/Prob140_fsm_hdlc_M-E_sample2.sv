module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: 3 bits enough
    localparam S0  = 3'd0; // 0 consecutive ones
    localparam S1  = 3'd1; // 1 consecutive one
    localparam S2  = 3'd2; // 2 consecutive ones
    localparam S3  = 3'd3; // 3 consecutive ones
    localparam S4  = 3'd4; // 4 consecutive ones
    localparam S5  = 3'd5; // 5 consecutive ones
    localparam S6  = 3'd6; // 6 consecutive ones
    localparam ERR = 3'd7; // Error state: 7 or more consecutive ones

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in)
                    next_state = S6;
                else
                    next_state = S0;
            end
            S6: begin
                if (in)
                    next_state = ERR;
                else
                    next_state = S0;
            end
            ERR: begin
                if (in)
                    next_state = ERR;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore): outputs asserted one cycle after condition is detected
    // Conditions:
    // disc = 1 in S5 (previous cycle we had 5 ones, input zero means zero inserted after five ones)
    // flag = 1 in S6 (previous cycle we had 6 ones, input zero means flag pattern detected)
    // err  = 1 in ERR (7 or more ones)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= (state == S5);
            flag <= (state == S6);
            err  <= (state == ERR);
        end
    end

endmodule