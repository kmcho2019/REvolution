module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

// Initialize next_state to zero
reg [9:0] next_state_reg;
reg out1_reg, out2_reg;

integer i;
always @(*) begin
    next_state_reg = 10'b0;
    out1_reg = 0;
    out2_reg = 0;

    // For each active state bit, compute next state and outputs
    // S0 (state[0])
    if (state[0]) begin
        // S0 --0--> S0, --1--> S1
        if (in == 1'b0) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[1] = 1'b1;
        end
        // S0 outputs (0,0)
        // no change to out1_reg, out2_reg
    end

    // S1 (state[1])
    if (state[1]) begin
        // S1 --0--> S0, --1--> S2
        if (in == 1'b0) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[2] = 1'b1;
        end
        // outputs (0,0)
    end

    // S2 (state[2])
    if (state[2]) begin
        // S2 --0--> S0, --1--> S3
        if (in == 1'b0) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[3] = 1'b1;
        end
        // outputs (0,0)
    end

    // S3 (state[3])
    if (state[3]) begin
        // S3 --0--> S0, --1--> S4
        if (in == 1'b0) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[4] = 1'b1;
        end
        // outputs (0,0)
    end

    // S4 (state[4])
    if (state[4]) begin
        // S4 --0--> S0, --1--> S5
        if (in == 1'b0) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[5] = 1'b1;
        end
        // outputs (0,0)
    end

    // S5 (state[5])
    if (state[5]) begin
        // S5 --0--> S8, --1--> S6
        if (in == 1'b0) begin
            next_state_reg[8] = 1'b1;
        end else begin
            next_state_reg[6] = 1'b1;
        end
        // outputs (0,0)
    end

    // S6 (state[6])
    if (state[6]) begin
        // S6 --0--> S9, --1--> S7
        if (in == 1'b0) begin
            next_state_reg[9] = 1'b1;
        end else begin
            next_state_reg[7] = 1'b1;
        end
        // outputs (0,0)
    end

    // S7 (state[7])
    if (state[7]) begin
        // S7 (0,1) --0--> S0, --1--> S7
        if (in == 1'b0) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[7] = 1'b1;
        end
        // outputs (0,1)
        out1_reg = out1_reg | 1'b0;
        out2_reg = out2_reg | 1'b1;
    end

    // S8 (state[8])
    if (state[8]) begin
        // S8 (1,0) --0--> S0, --1--> S1
        if (in == 1'b0) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[1] = 1'b1;
        end
        // outputs (1,0)
        out1_reg = out1_reg | 1'b1;
        out2_reg = out2_reg | 1'b0;
    end

    // S9 (state[9])
    if (state[9]) begin
        // S9 (1,1) --0--> S0, --1--> S1
        if (in == 1'b0) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[1] = 1'b1;
        end
        // outputs (1,1)
        out1_reg = out1_reg | 1'b1;
        out2_reg = out2_reg | 1'b1;
    end
end

assign next_state = next_state_reg;
assign out1 = out1_reg;
assign out2 = out2_reg;

endmodule