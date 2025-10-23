module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// State register
reg [2:0] state;

// Initialize state to S0 (0)
initial state = 3'b000;

// Next state logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 1'b0;
    end else begin
        case (state)
            3'b000: begin
                if (IN) begin
                    state <= 3'b001;
                end
                MATCH <= 1'b0;
            end
            3'b001: begin
                if (~IN) begin
                    state <= 3'b010;
                end else begin
                    state <= 3'b000;
                end
                MATCH <= 1'b0;
            end
            3'b010: begin
                if (~IN) begin
                    state <= 3'b011;
                end else begin
                    state <= 3'b000;
                end
                MATCH <= 1'b0;
            end
            3'b011: begin
                if (IN) begin
                    state <= 3'b100;
                end else begin
                    state <= 3'b000;
                end
                MATCH <= 1'b0;
            end
            3'b100: begin
                if (IN) begin
                    state <= 3'b100;
                    MATCH <= 1'b1;
                end else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= 3'b000;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule