module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0100;
parameter S4 = 4'b1000;
parameter S5 = 4'b1001;

reg [3:0] state;
reg [3:0] next_state;

assign MATCH = (state == S5 && IN == 1) ? 1'b1 : 1'b0;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
    end else begin
        case(state)
            S0: begin
                if (IN == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (IN == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (IN == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
            end
            S3: begin
                if (IN == 1'b1) begin
                    state <= S4;
                end else begin
                    state <= S0;
                end
            end
            S4: begin
                if (IN == 1'b1) begin
                    state <= S5;
                end else begin
                    state <= S0;
                end
            end
            S5: begin
                if (IN == 1'b1) begin
                    state <= S5;
                end else begin
                    state <= S0;
                end
            end
        endcase
    end
end

endmodule