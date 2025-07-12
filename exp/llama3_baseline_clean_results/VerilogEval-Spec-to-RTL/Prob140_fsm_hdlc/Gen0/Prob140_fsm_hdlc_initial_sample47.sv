module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;
parameter S7 = 3'b111;

reg [2:0] state, nextState;

// Outputs
reg disc_reg, flag_reg, err_reg;

// Combinational logic for next state and output
always @(*) begin
    case (state)
        S0: begin
            if (in) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S1: begin
            if (in) begin
                nextState = S2;
            end else begin
                nextState = S0;
            end
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S2: begin
            if (in) begin
                nextState = S3;
            end else begin
                nextState = S0;
            end
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S3: begin
            if (in) begin
                nextState = S4;
            end else begin
                nextState = S0;
            end
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S4: begin
            if (in) begin
                nextState = S5;
            end else begin
                nextState = S0;
            end
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        S5: begin
            if (in) begin
                nextState = S6;
            end else begin
                nextState = S0;
                disc_reg = 1; // Signal to discard the bit
            end
            flag_reg = 0;
            err_reg = 0;
        end
        S6: begin
            if (in) begin
                nextState = S7;
            end else begin
                nextState = S0;
                flag_reg = 1; // Signal the start/end of a frame
            end
            disc_reg = 0;
            err_reg = 0;
        end
        S7: begin
            if (in) begin
                nextState = S7;
            end else begin
                nextState = S0;
            end
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 1; // Signal an error
        end
        default: begin
            nextState = S0;
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
    endcase
end

// Sequential logic for state register
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
    end else begin
        state <= nextState;
    end
    disc <= disc_reg;
    flag <= flag_reg;
    err <= err_reg;
end

endmodule