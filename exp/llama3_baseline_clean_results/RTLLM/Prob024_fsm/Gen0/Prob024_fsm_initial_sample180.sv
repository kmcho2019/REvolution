module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;

reg [3:0] current_state;
reg [3:0] next_state;

always @(*) begin
    case (current_state)
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
                next_state = S2;
            end else if (IN == 1'b1) begin
                next_state = S3;
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
            if (IN == 1'b1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S5 && IN == 1'b1) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

endmodule