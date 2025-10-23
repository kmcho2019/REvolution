module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Define the state groups
    wire [4:0] group1;
    wire [4:0] group2;

    // Assign the state bits to their respective groups
    assign group1 = {state[9], state[8], state[7], state[6], state[5]};
    assign group2 = {state[4], state[3], state[2], state[1], state[0]};

    // Define the transition encodings
    wire [2:0] transition1;
    wire [2:0] transition2;

    // Define the next state logic for each group
    wire [4:0] next_group1;
    wire [4:0] next_group2;

    // Define the output logic
    reg out1_reg;
    reg out2_reg;

    // Implement the transition encoding logic
    always @(*) begin
        transition1 = 3'b000;
        transition2 = 3'b000;

        if (group1 != 5'b00000) begin
            case (1'b1)
                1'b1: begin
                    if (in) begin
                        case (group1)
                            5'b10000: transition1 = 3'b001; // S9 -> S1
                            5'b01000: transition1 = 3'b010; // S8 -> S0
                            5'b00100: transition1 = 3'b011; // S7 -> S7
                            5'b00010: transition1 = 3'b100; // S6 -> S9
                            5'b00001: transition1 = 3'b101; // S5 -> S8
                        endcase
                    end else begin
                        case (group1)
                            5'b10000: transition1 = 3'b000; // S9 -> S0
                            5'b01000: transition1 = 3'b000; // S8 -> S0
                            5'b00100: transition1 = 3'b000; // S7 -> S0
                            5'b00010: transition1 = 3'b000; // S6 -> S0
                            5'b00001: transition1 = 3'b000; // S5 -> S0
                        endcase
                    end
                end
            endcase
        end

        if (group2 != 5'b00000) begin
            case (1'b1)
                1'b1: begin
                    if (in) begin
                        case (group2)
                            5'b10000: transition2 = 3'b001; // S4 -> S5
                            5'b01000: transition2 = 3'b010; // S3 -> S4
                            5'b00100: transition2 = 3'b011; // S2 -> S3
                            5'b00010: transition2 = 3'b100; // S1 -> S2
                            5'b00001: transition2 = 3'b101; // S0 -> S1
                        endcase
                    end else begin
                        case (group2)
                            5'b10000: transition2 = 3'b000; // S4 -> S0
                            5'b01000: transition2 = 3'b000; // S3 -> S0
                            5'b00100: transition2 = 3'b000; // S2 -> S0
                            5'b00010: transition2 = 3'b000; // S1 -> S0
                            5'b00001: transition2 = 3'b000; // S0 -> S0
                        endcase
                    end
                end
            endcase
        end
    end

    // Implement the next state logic
    always @(*) begin
        next_group1 = 5'b00000;
        next_group2 = 5'b00000;

        if (transition1 == 3'b001) begin
            next_group1 = 5'b01000; // S9 -> S1
        end else if (transition1 == 3'b010) begin
            next_group1 = 5'b00001; // S8 -> S0
        end else if (transition1 == 3'b011) begin
            next_group1 = 5'b00100; // S7 -> S7
        end else if (transition1 == 3'b100) begin
            next_group1 = 5'b00010; // S6 -> S9
        end else if (transition1 == 3'b101) begin
            next_group1 = 5'b00001; // S5 -> S8
        end

        if (transition2 == 3'b001) begin
            next_group2 = 5'b00001; // S4 -> S5
        end else if (transition2 == 3'b010) begin
            next_group2 = 5'b00010; // S3 -> S4
        end else if (transition2 == 3'b011) begin
            next_group2 = 5'b00100; // S2 -> S3
        end else if (transition2 == 3'b100) begin
            next_group2 = 5'b01000; // S1 -> S2
        end else if (transition2 == 3'b101) begin
            next_group2 = 5'b10000; // S0 -> S1
        end
    end

    // Implement the output logic
    always @(*) begin
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        if (group1 == 5'b10000 || group1 == 5'b01000 || group1 == 5'b00100 || group1 == 5'b00010) begin
            out1_reg = 1'b1;
        end

        if (group1 == 5'b00100) begin
            out2_reg = 1'b1;
        end
    end

    // Assign the next state outputs
    assign next_state[9:5] = next_group1;
    assign next_state[4:0] = next_group2;

    // Assign the output signals
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule