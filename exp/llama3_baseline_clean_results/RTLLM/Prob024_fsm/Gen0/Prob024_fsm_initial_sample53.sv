module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;

reg [3:0] state;
reg [3:0] next_state;

always @(*) begin
    case (state)
        S0: begin
            if (IN == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN == 1'b1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            next_state = S0;
        end
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S5 && IN == 1'b1) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

endmodule