module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state;
reg [2:0] nextState;
reg fr2_reg;
reg fr1_reg;
reg fr0_reg;
reg dfr_reg;

always @(posedge clk) begin
    if(reset) begin
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        state <= 3'b0;
    end else begin
        state <= nextState;
        fr2_reg <= fr2;
        fr1_reg <= fr1;
        fr0_reg <= fr0;
        dfr_reg <= dfr;
    end
end

always @(*) begin
    case(state)
        3'b000: begin // All sensors low
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            if(s[0] == 1'b0) begin
                dfr = 1'b1;
            end else if(s[0] == 1'b1 && s[1] == 1'b0) begin
                dfr = 1'b0;
            end else if(s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b0) begin
                dfr = 1'b0;
            end else if(s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b1) begin
                dfr = 1'b0;
            end
            if(s[0] == 1'b1) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b000;
            end
        end
        3'b001: begin // Only s[0] high
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            if(s[0] == 1'b1 && s[1] == 1'b1) begin
                dfr = 1'b1;
            end else if(s[0] == 1'b1 && s[1] == 1'b0) begin
                dfr = 1'b0;
            end else if(s[0] == 1'b0) begin
                dfr = 1'b1;
            end
            if(s[1] == 1'b1) begin
                nextState = 3'b010;
            end else if(s[0] == 1'b0) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
        end
        3'b010: begin // s[0] and s[1] high
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            if(s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b1) begin
                dfr = 1'b1;
            end else if(s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b0) begin
                dfr = 1'b1;
            end else if(s[0] == 1'b1 && s[1] == 1'b0) begin
                dfr = 1'b0;
            end else if(s[0] == 1'b0) begin
                dfr = 1'b1;
            end
            if(s[2] == 1'b1) begin
                nextState = 3'b100;
            end else if(s[0] == 1'b0) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
        end
        3'b100: begin // All sensors high
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
            if(s[2] == 1'b0) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b100;
            end
        end
        default: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
            nextState = 3'b000;
        end
    endcase
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule