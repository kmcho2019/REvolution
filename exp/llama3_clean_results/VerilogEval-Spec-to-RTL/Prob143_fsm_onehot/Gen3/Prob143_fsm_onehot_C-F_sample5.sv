module TopModule(
    input  in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        // State transitions and output logic
        if (state[0] == 1'b1) begin // S0
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[1] = 1'b1;
            end
        end else if (state[1] == 1'b1) begin // S1
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[2] = 1'b1;
            end
        end else if (state[2] == 1'b1) begin // S2
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[3] = 1'b1;
            end
        end else if (state[3] == 1'b1) begin // S3
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[4] = 1'b1;
            end
        end else if (state[4] == 1'b1) begin // S4
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[5] = 1'b1;
            end
        end else if (state[5] == 1'b1) begin // S5
            if (in == 1'b0) begin
                next_state_reg[8] = 1'b1;
            end else begin
                next_state_reg[6] = 1'b1;
            end
        end else if (state[6] == 1'b1) begin // S6
            if (in == 1'b0) begin
                next_state_reg[9] = 1'b1;
            end else begin
                next_state_reg[7] = 1'b1;
            end
        end else if (state[7] == 1'b1) begin // S7
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[7] = 1'b1;
            end
            out2_reg = 1'b1;
        end else if (state[8] == 1'b1) begin // S8
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[1] = 1'b1;
            end
            out1_reg = 1'b1;
        end else if (state[9] == 1'b1) begin // S9
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[1] = 1'b1;
            end
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule