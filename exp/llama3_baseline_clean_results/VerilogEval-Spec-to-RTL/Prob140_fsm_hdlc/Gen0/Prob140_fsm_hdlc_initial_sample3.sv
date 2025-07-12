module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// Define states
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;

// Current state and next state
reg [2:0] cs, ns;

// Output registers
reg disc_reg, flag_reg, err_reg;

// Combinational logic for next state
always @(*) begin
    case(cs)
        S0: if(in) ns = S1; else ns = S0;
        S1: if(in) ns = S2; else ns = S0;
        S2: if(in) ns = S3; else ns = S0;
        S3: if(in) ns = S4; else ns = S0;
        S4: if(in) ns = S5; else ns = S0;
        S5: if(in) ns = S6; else if(!in) ns = S0; else ns = S5;
        S6: if(in) ns = S7; else ns = S0;
        S7: if(in) ns = S7; else ns = S0;
        default: ns = S0;
    endcase
end

// Combinational logic for output
always @(*) begin
    disc_reg = (cs == S5 && !in);
    flag_reg = (cs == S6);
    err_reg = (cs == S7);
end

// Sequential logic for state and output registers
always @(posedge clk) begin
    if(reset) begin
        cs <= S0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        cs <= ns;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

endmodule