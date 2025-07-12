module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    // State indices for clarity
    localparam S0 = 0;
    localparam S1 = 1;
    localparam S2 = 2;
    localparam S3 = 3;
    localparam S4 = 4;
    localparam S5 = 5;
    localparam S6 = 6;
    localparam S7 = 7;
    localparam S8 = 8;
    localparam S9 = 9;

    integer i;
    reg [9:0] next_state_acc;

    always @(*) begin
        next_state_acc = 10'b0;

        // For each active state, determine transitions based on input
        for (i = 0; i < 10; i = i + 1) begin
            if (state[i]) begin
                case (i)
                    S0: begin
                        // S0 --0--> S0 ; --1--> S1
                        if (in)
                            next_state_acc[S1] = 1'b1;
                        else
                            next_state_acc[S0] = 1'b1;
                    end
                    S1: begin
                        // S1 --0--> S0 ; --1--> S2
                        if (in)
                            next_state_acc[S2] = 1'b1;
                        else
                            next_state_acc[S0] = 1'b1;
                    end
                    S2: begin
                        // S2 --0--> S0 ; --1--> S3
                        if (in)
                            next_state_acc[S3] = 1'b1;
                        else
                            next_state_acc[S0] = 1'b1;
                    end
                    S3: begin
                        // S3 --0--> S0 ; --1--> S4
                        if (in)
                            next_state_acc[S4] = 1'b1;
                        else
                            next_state_acc[S0] = 1'b1;
                    end
                    S4: begin
                        // S4 --0--> S0 ; --1--> S5
                        if (in)
                            next_state_acc[S5] = 1'b1;
                        else
                            next_state_acc[S0] = 1'b1;
                    end
                    S5: begin
                        // S5 --0--> S8 ; --1--> S6
                        if (in)
                            next_state_acc[S6] = 1'b1;
                        else
                            next_state_acc[S8] = 1'b1;
                    end
                    S6: begin
                        // S6 --0--> S9 ; --1--> S7
                        if (in)
                            next_state_acc[S7] = 1'b1;
                        else
                            next_state_acc[S9] = 1'b1;
                    end
                    S7: begin
                        // S7 --0--> S0 ; --1--> S7
                        if (in)
                            next_state_acc[S7] = 1'b1;
                        else
                            next_state_acc[S0] = 1'b1;
                    end
                    S8: begin
                        // S8 --0--> S0 ; --1--> S1
                        if (in)
                            next_state_acc[S1] = 1'b1;
                        else
                            next_state_acc[S0] = 1'b1;
                    end
                    S9: begin
                        // S9 --0--> S0 ; --1--> S1
                        if (in)
                            next_state_acc[S1] = 1'b1;
                        else
                            next_state_acc[S0] = 1'b1;
                    end
                    default: begin
                        // no transition
                        next_state_acc[i] = 1'b0;
                    end
                endcase
            end
        end

        next_state = next_state_acc;
    end

    // Outputs depend on next_state: 
    // out1 = 1 if next state is S8 or S9
    // out2 = 1 if next state is S7 or S9

    assign out1 = next_state[S8] | next_state[S9];
    assign out2 = next_state[S7] | next_state[S9];

endmodule