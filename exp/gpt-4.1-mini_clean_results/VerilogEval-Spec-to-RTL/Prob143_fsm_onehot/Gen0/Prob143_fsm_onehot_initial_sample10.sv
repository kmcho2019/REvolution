module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    reg [9:0] next_state_reg;
    reg       out1_reg;
    reg       out2_reg;

    integer i;
    always @(*) begin
        next_state_reg = 10'b0;
        out1_reg = 0;
        out2_reg = 0;

        // For each possible current state, if active, determine next state(s) and outputs
        if(state[0]) begin // S0 (0,0)
            if(in == 0) begin
                next_state_reg[0] = 1; // S0
            end else begin
                next_state_reg[1] = 1; // S1
            end
            // outputs (0,0)
        end

        if(state[1]) begin // S1 (0,0)
            if(in == 0) begin
                next_state_reg[0] = 1; // S0
            end else begin
                next_state_reg[2] = 1; // S2
            end
            // outputs (0,0)
        end

        if(state[2]) begin // S2 (0,0)
            if(in == 0) begin
                next_state_reg[0] = 1; // S0
            end else begin
                next_state_reg[3] = 1; // S3
            end
            // outputs (0,0)
        end

        if(state[3]) begin // S3 (0,0)
            if(in == 0) begin
                next_state_reg[0] = 1; // S0
            end else begin
                next_state_reg[4] = 1; // S4
            end
            // outputs (0,0)
        end

        if(state[4]) begin // S4 (0,0)
            if(in == 0) begin
                next_state_reg[0] = 1; // S0
            end else begin
                next_state_reg[5] = 1; // S5
            end
            // outputs (0,0)
        end

        if(state[5]) begin // S5 (0,0)
            if(in == 0) begin
                next_state_reg[8] = 1; // S8
            end else begin
                next_state_reg[6] = 1; // S6
            end
            // outputs (0,0)
        end

        if(state[6]) begin // S6 (0,0)
            if(in == 0) begin
                next_state_reg[9] = 1; // S9
            end else begin
                next_state_reg[7] = 1; // S7
            end
            // outputs (0,0)
        end

        if(state[7]) begin // S7 (0,1)
            if(in == 0) begin
                next_state_reg[0] = 1; // S0
            end else begin
                next_state_reg[7] = 1; // S7
            end
            // outputs (0,1)
            out2_reg = 1;
        end

        if(state[8]) begin // S8 (1,0)
            if(in == 0) begin
                next_state_reg[0] = 1; // S0
            end else begin
                next_state_reg[1] = 1; // S1
            end
            // outputs (1,0)
            out1_reg = 1;
        end

        if(state[9]) begin // S9 (1,1)
            if(in == 0) begin
                next_state_reg[0] = 1; // S0
            end else begin
                next_state_reg[1] = 1; // S1
            end
            // outputs (1,1)
            out1_reg = 1;
            out2_reg = 1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule