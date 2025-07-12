module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // 6 states: S0, S1, S2, S3, S4, S5
reg [2:0] next_state;
reg match;

always @(*) begin
    case (state)
        3'b000: begin // S0
            if (IN) begin
                next_state = 3'b001; // S1
                match = 1'b0;
            end else begin
                next_state = 3'b000; // S0
                match = 1'b0;
            end
        end
        3'b001: begin // S1
            if (~IN) begin
                next_state = 3'b010; // S2
                match = 1'b0;
            end else begin
                next_state = 3'b001; // S1
                match = 1'b0;
            end
        end
        3'b010: begin // S2
            if (~IN) begin
                next_state = 3'b011; // S3
                match = 1'b0;
            end else begin
                next_state = 3'b001; // S1
                match = 1'b0;
            end
        end
        3'b011: begin // S3
            if (IN) begin
                next_state = 3'b100; // S4
                match = 1'b0;
            end else begin
                next_state = 3'b000; // S0
                match = 1'b0;
            end
        end
        3'b100: begin // S4
            if (IN) begin
                next_state = 3'b101; // S5
                match = 1'b1;
            end else begin
                next_state = 3'b000; // S0
                match = 1'b0;
            end
        end
        3'b101: begin // S5
            if (IN) begin
                next_state = 3'b101; // S5
                match = 1'b1;
            end else begin
                next_state = 3'b000; // S0
                match = 1'b0;
            end
        end
        default: begin
            next_state = 3'b000; // S0
            match = 1'b0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // S0
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match;
    end
end

endmodule