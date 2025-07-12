module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define FSM states representing count of consecutive 1s
    typedef enum logic [3:0] {
        S_0  = 4'd0, // no consecutive ones
        S_1  = 4'd1,
        S_2  = 4'd2,
        S_3  = 4'd3,
        S_4  = 4'd4,
        S_5  = 4'd5,
        S_6  = 4'd6,
        S_ERR= 4'd7   // 7 or more consecutive ones (error state)
    } state_t;

    state_t state, next_state;

    // Outputs depend on current state and input transition (Moore outputs)
    // disc: asserted for one cycle immediately after detecting 5 consecutive ones followed by 0 (0 after 5 ones)
    // flag: asserted for one cycle immediately after detecting 6 consecutive ones followed by 0 (0 after 6 ones)
    // err: asserted whenever 7 or more consecutive ones (S_ERR state)

    // Combinational next state logic
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        next_state = state;

        case (state)
            S_0: begin
                if (in)
                    next_state = S_1;
                else
                    next_state = S_0;
            end
            S_1: begin
                if (in)
                    next_state = S_2;
                else
                    next_state = S_0;
            end
            S_2: begin
                if (in)
                    next_state = S_3;
                else
                    next_state = S_0;
            end
            S_3: begin
                if (in)
                    next_state = S_4;
                else
                    next_state = S_0;
            end
            S_4: begin
                if (in)
                    next_state = S_5;
                else
                    next_state = S_0;
            end
            S_5: begin
                if (in)
                    next_state = S_6;
                else begin
                    next_state = S_0;
                    disc = 1'b1; // zero after 5 ones => discard bit
                end
            end
            S_6: begin
                if (in)
                    next_state = S_ERR;
                else begin
                    next_state = S_0;
                    flag = 1'b1; // zero after 6 ones => flag detected
                end
            end
            S_ERR: begin
                // Once in error state, stay here if input=1 (7+ ones)
                if (in)
                    next_state = S_ERR;
                else
                    next_state = S_0; // reset count after zero
                err = 1'b1; // error asserted while in S_ERR
            end
            default: next_state = S_0;
        endcase
    end

    // Sequential logic: register state and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= S_0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs already assigned in combinational block (Moore)
            // but outputs are registered here to be asserted for one clock cycle
            disc  <= disc;
            flag  <= flag;
            err   <= err;
        end
    end

endmodule