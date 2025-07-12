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
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000; // S0
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        state <= nextState;
        disc_reg <= (nextState == 3'b101);
        flag_reg <= (nextState == 3'b110);
        err_reg <= (nextState >= 3'b111);
    end
end

always @(*) begin
    case(state)
        3'b000: begin // S0
            if(in)
                nextState = 3'b001; // S1
            else
                nextState = 3'b000; // S0
        end
        3'b001: begin // S1
            if(in)
                nextState = 3'b010; // S2
            else
                nextState = 3'b000; // S0
        end
        3'b010: begin // S2
            if(in)
                nextState = 3'b011; // S3
            else
                nextState = 3'b000; // S0
        end
        3'b011: begin // S3
            if(in)
                nextState = 3'b100; // S4
            else
                nextState = 3'b000; // S0
        end
        3'b100: begin // S4
            if(in)
                nextState = 3'b101; // S5
            else
                nextState = 3'b000; // S0
        end
        3'b101: begin // S5
            if(in)
                nextState = 3'b110; // S6
            else
                nextState = 3'b000; // S0
        end
        3'b110: begin // S6
            if(in)
                nextState = 3'b111; // S7
            else
                nextState = 3'b000; // S0
        end
        default: begin // S7
            if(in)
                nextState = 3'b111; // S7
            else
                nextState = 3'b000; // S0
        end
    endcase
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule