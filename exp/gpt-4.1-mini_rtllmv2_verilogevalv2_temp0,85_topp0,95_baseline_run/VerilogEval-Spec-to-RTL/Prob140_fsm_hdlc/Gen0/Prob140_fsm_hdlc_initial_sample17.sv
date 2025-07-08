module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    localparam [3:0]
        S0  = 4'd0, // 0 consecutive 1s
        S1  = 4'd1, // 1 consecutive 1
        S2  = 4'd2, // 2 consecutive 1s
        S3  = 4'd3, // 3 consecutive 1s
        S4  = 4'd4, // 4 consecutive 1s
        S5  = 4'd5, // 5 consecutive 1s
        S6  = 4'd6, // 6 consecutive 1s
        ERR = 4'd7; // error state (7 or more 1s)

    reg [3:0] state, next_state;

    // State transition combinational logic
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
                    next_state = ERR; // 7 or more consecutive ones -> error
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

    // Sequential logic: state update and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs to zero, assert only in specific states
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // Outputs based on current state (Moore outputs)
            case(next_state)
                // disc: after seeing 5 ones then 0, i.e. from S5->S0 on zero input
                S0: begin
                    if (state == S5 && in == 1'b0)
                        disc <= 1'b1; // discard zero after 5 ones
                    else if (state == S6 && in == 1'b0)
                        flag <= 1'b1; // flag after 6 ones then 0
                    else if (state == ERR)
                        err <= 1'b1;
                end
                ERR: begin
                    err <= 1'b1;
                end
                default: begin
                    // no outputs asserted in other states
                    disc <= 1'b0;
                    flag <= 1'b0;
                    err  <= 1'b0;
                end
            endcase
        end
    end

endmodule