module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    wire [3:0] encoded_state;
    wire [9:0] next_state_wire;
    wire out1_wire;
    wire out2_wire;

    // Priority encoder to determine the highest-priority active state
    priority_encoder pe (
       .state(state),
       .encoded_state(encoded_state)
    );

    // Lookup table to store next state and output values for each state
    lookup_table lut (
       .encoded_state(encoded_state),
       .in(in),
       .next_state(next_state_wire),
       .out1(out1_wire),
       .out2(out2_wire)
    );

    // Assign next state and output values
    assign next_state = next_state_wire;
    assign out1 = out1_wire;
    assign out2 = out2_wire;

endmodule

module priority_encoder(
    input [9:0] state,
    output [3:0] encoded_state
);

    reg [3:0] encoded_state_reg;
    always @(*) begin
        encoded_state_reg = 4'b0000;
        if (state[9]) encoded_state_reg = 4'b1001;
        else if (state[8]) encoded_state_reg = 4'b1000;
        else if (state[7]) encoded_state_reg = 4'b0111;
        else if (state[6]) encoded_state_reg = 4'b0110;
        else if (state[5]) encoded_state_reg = 4'b0101;
        else if (state[4]) encoded_state_reg = 4'b0100;
        else if (state[3]) encoded_state_reg = 4'b0011;
        else if (state[2]) encoded_state_reg = 4'b0010;
        else if (state[1]) encoded_state_reg = 4'b0001;
        else if (state[0]) encoded_state_reg = 4'b0000;
    end
    assign encoded_state = encoded_state_reg;

endmodule

module lookup_table(
    input [3:0] encoded_state,
    input in,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;
    always @(*) begin
        next_state_reg = 10'b0;
        out1_reg = 1'b0;
        out2_reg = 1'b0;
        case (encoded_state)
            4'b1001: begin // S9
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
                out1_reg = 1'b1;
                out2_reg = 1'b1;
            end
            4'b1000: begin // S8
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
                out1_reg = 1'b1;
                out2_reg = 1'b0;
            end
            4'b0111: begin // S7
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[7] = 1'b1;
                end
                out1_reg = 1'b0;
                out2_reg = 1'b1;
            end
            4'b0110: begin // S6
                if (in == 1'b0) begin
                    next_state_reg[9] = 1'b1;
                end else begin
                    next_state_reg[7] = 1'b1;
                end
            end
            4'b0101: begin // S5
                if (in == 1'b0) begin
                    next_state_reg[8] = 1'b1;
                end else begin
                    next_state_reg[6] = 1'b1;
                end
            end
            4'b0100: begin // S4
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[5] = 1'b1;
                end
            end
            4'b0011: begin // S3
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[4] = 1'b1;
                end
            end
            4'b0010: begin // S2
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[3] = 1'b1;
                end
            end
            4'b0001: begin // S1
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[2] = 1'b1;
                end
            end
            4'b0000: begin // S0
                if (in == 1'b0) begin
                    next_state_reg[0] = 1'b1;
                end else begin
                    next_state_reg[1] = 1'b1;
                end
            end
            default: begin
                next_state_reg[0] = 1'b1; // Default to S0 if no match
            end
        endcase
    end
    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule