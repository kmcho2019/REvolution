module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [4:0] binary_state;
    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    // Binary encoder
    always @(*) begin
        case (1'b1)
            state[0]: binary_state = 5'b00001;
            state[1]: binary_state = 5'b00010;
            state[2]: binary_state = 5'b00011;
            state[3]: binary_state = 5'b00100;
            state[4]: binary_state = 5'b00101;
            state[5]: binary_state = 5'b00110;
            state[6]: binary_state = 5'b00111;
            state[7]: binary_state = 5'b01000;
            state[8]: binary_state = 5'b01001;
            state[9]: binary_state = 5'b01010;
        endcase
    end

    // Lookup table
    reg [9:0] next_state_lut [5:0];
    reg [1:0] out_lut [5:0];

    initial begin
        next_state_lut[0] = {10{1'b0}};
        out_lut[0] = 2'b00;
        next_state_lut[1] = {10{1'b0}};
        out_lut[1] = 2'b00;
        next_state_lut[2] = {10{1'b0}};
        out_lut[2] = 2'b00;
        next_state_lut[3] = {10{1'b0}};
        out_lut[3] = 2'b00;
        next_state_lut[4] = {10{1'b0}};
        out_lut[4] = 2'b00;
        next_state_lut[5] = {10{1'b0}};
        out_lut[5] = 2'b00;
        next_state_lut[6] = {10{1'b0}};
        out_lut[6] = 2'b00;
        next_state_lut[7] = {10{1'b0}};
        out_lut[7] = 2'b01;
        next_state_lut[8] = {10{1'b0}};
        out_lut[8] = 2'b10;
        next_state_lut[9] = {10{1'b0}};
        out_lut[9] = 2'b11;
    end

    // Combinational logic
    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        if (binary_state == 5'b00001) begin
            if (in) begin
                next_state_lut[0] = 10'b0000000001;
            end else begin
                next_state_lut[0] = 10'b1000000000;
            end
        end else if (binary_state == 5'b00010) begin
            if (in) begin
                next_state_lut[1] = 10'b0000000010;
            end else begin
                next_state_lut[1] = 10'b1000000000;
            end
        end else if (binary_state == 5'b00011) begin
            if (in) begin
                next_state_lut[2] = 10'b0000000100;
            end else begin
                next_state_lut[2] = 10'b1000000000;
            end
        end else if (binary_state == 5'b00100) begin
            if (in) begin
                next_state_lut[3] = 10'b0000001000;
            end else begin
                next_state_lut[3] = 10'b1000000000;
            end
        end else if (binary_state == 5'b00101) begin
            if (in) begin
                next_state_lut[4] = 10'b0000010000;
            end else begin
                next_state_lut[4] = 10'b1000000000;
            end
        end else if (binary_state == 5'b00110) begin
            if (in) begin
                next_state_lut[5] = 10'b0000100000;
            end else begin
                next_state_lut[5] = 10'b1000000000;
            end
        end else if (binary_state == 5'b00111) begin
            if (in) begin
                next_state_lut[6] = 10'b0001000000;
            end else begin
                next_state_lut[6] = 10'b1000000000;
            end
        end else if (binary_state == 5'b01000) begin
            if (in) begin
                next_state_lut[7] = 10'b0010000000;
            end else begin
                next_state_lut[7] = 10'b1000000000;
            end
        end else if (binary_state == 5'b01001) begin
            if (in) begin
                next_state_lut[8] = 10'b0100000000;
            end else begin
                next_state_lut[8] = 10'b1000000000;
            end
        end else if (binary_state == 5'b01010) begin
            if (in) begin
                next_state_lut[9] = 10'b1000000000;
            end else begin
                next_state_lut[9] = 10'b1000000000;
            end
        end

        // Update next_state and outputs
        next_state_reg = next_state_lut[binary_state];
        out1_reg = out_lut[binary_state][1];
        out2_reg = out_lut[binary_state][0];
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule