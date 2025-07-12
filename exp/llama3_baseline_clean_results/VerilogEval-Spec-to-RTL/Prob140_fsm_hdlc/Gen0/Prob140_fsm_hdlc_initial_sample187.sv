module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // current state
reg [2:0] nextState; // next state

// Define the states
localparam S0 = 3'b000; // initial state
localparam S1 = 3'b001; // one consecutive 1
localparam S2 = 3'b010; // two consecutive 1s
localparam S3 = 3'b011; // three consecutive 1s
localparam S4 = 3'b100; // four consecutive 1s
localparam S5 = 3'b101; // five consecutive 1s, expecting a 0
localparam S6 = 3'b110; // six consecutive 1s, flag detected
localparam Err = 3'b111; // error state, seven or more consecutive 1s

// Output signals
reg disc_reg;
reg flag_reg;
reg err_reg;

always @(*) begin
    case (state)
        S0: begin
            if (in) begin
                nextState = S1;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = S0;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        S1: begin
            if (in) begin
                nextState = S2;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = S0;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        S2: begin
            if (in) begin
                nextState = S3;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = S0;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        S3: begin
            if (in) begin
                nextState = S4;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = S0;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        S4: begin
            if (in) begin
                nextState = S5;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = S0;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        S5: begin
            if (in) begin
                nextState = Err;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b1;
            end else begin
                nextState = S0;
                disc_reg = 1'b1;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        S6: begin
            if (in) begin
                nextState = Err;
                disc_reg = 1'b0;
                flag_reg = 1'b1;
                err_reg = 1'b1;
            end else begin
                nextState = S0;
                disc_reg = 1'b0;
                flag_reg = 1'b1;
                err_reg = 1'b0;
            end
        end
        Err: begin
            if (in) begin
                nextState = Err;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b1;
            end else begin
                nextState = S0;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        default: begin
            nextState = S0;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
    end else begin
        state <= nextState;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

endmodule