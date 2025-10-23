module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg [2:0] nextState;
reg disc_reg;
reg flag_reg;
reg err_reg;

// State encoding
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;
parameter S7 = 3'b111;

// Output signals
assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

// Next state logic
always @(*) begin
    case(state)
        S0: begin
            if(in) nextState = S1;
            else nextState = S0;
        end
        S1: begin
            if(in) nextState = S2;
            else nextState = S0;
        end
        S2: begin
            if(in) nextState = S3;
            else nextState = S0;
        end
        S3: begin
            if(in) nextState = S4;
            else nextState = S0;
        end
        S4: begin
            if(in) nextState = S5;
            else nextState = S0;
        end
        S5: begin
            if(in) nextState = S6;
            else begin
                disc_reg = 1'b1;
                nextState = S0;
            end
        end
        S6: begin
            if(in) nextState = S7;
            else begin
                flag_reg = 1'b1;
                nextState = S0;
            end
        end
        S7: begin
            if(in) nextState = S7;
            else begin
                err_reg = 1'b1;
                nextState = S0;
            end
        end
        default: nextState = S0;
    endcase
end

// State update and output reset
always @(posedge clk) begin
    if(reset) begin
        state <= S0;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end
    else begin
        state <= nextState;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end
end

endmodule