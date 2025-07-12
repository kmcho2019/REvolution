module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Define the transition matrix T
    reg [9:0] T [9:0][1:0];
    initial begin
        T[0][0] = 10'b1;
        T[0][1] = 10'b10;
        T[1][0] = 10'b1;
        T[1][1] = 10'b100;
        T[2][0] = 10'b1;
        T[2][1] = 10'b1000;
        T[3][0] = 10'b1;
        T[3][1] = 10'b10000;
        T[4][0] = 10'b1;
        T[4][1] = 10'b100000;
        T[5][0] = 10'b100000000;
        T[5][1] = 10'b1000000;
        T[6][0] = 10'b1000000000;
        T[6][1] = 10'b10000000;
        T[7][0] = 10'b1;
        T[7][1] = 10'b10000000;
        T[8][0] = 10'b1;
        T[8][1] = 10'b10;
        T[9][0] = 10'b1;
        T[9][1] = 10'b10;
    end

    // Define the output matrix O
    reg [1:0] O [9:0];
    initial begin
        O[0] = 2'b00;
        O[1] = 2'b00;
        O[2] = 2'b00;
        O[3] = 2'b00;
        O[4] = 2'b00;
        O[5] = 2'b00;
        O[6] = 2'b00;
        O[7] = 2'b01;
        O[8] = 2'b10;
        O[9] = 2'b11;
    end

    // Perform matrix lookup and combinational logic
    reg [9:0] next_state_reg;
    reg [1:0] out_reg;
    always @(*) begin
        next_state_reg = 10'b0;
        out_reg = 2'b00;
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                next_state_reg = next_state_reg | T[i][in];
                out_reg = out_reg | O[i];
            end
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out_reg[0];
    assign out2 = out_reg[1];

endmodule