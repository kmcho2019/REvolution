module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// State register
reg [3:0] state;

// Initialize state to idle (0)
initial state = 4'b0000;

// Next state logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 4'b0000;
        MATCH <= 1'b0;
    end else begin
        case (state)
            4'b0000: begin
                if (IN) begin
                    state <= 4'b0001;
                end else begin
                    state <= 4'b0000;
                end
                MATCH <= 1'b0;
            end
            4'b0001: begin
                if (~IN) begin
                    state <= 4'b0010;
                end else begin
                    state <= 4'b0000;
                end
                MATCH <= 1'b0;
            end
            4'b0010: begin
                if (~IN) begin
                    state <= 4'b0011;
                end else begin
                    state <= 4'b0000;
                end
                MATCH <= 1'b0;
            end
            4'b0011: begin
                if (IN) begin
                    state <= 4'b0100;
                end else begin
                    state <= 4'b0000;
                end
                MATCH <= 1'b0;
            end
            4'b0100: begin
                if (IN) begin
                    state <= 4'b0100;
                    MATCH <= 1'b1;
                end else begin
                    state <= 4'b0000;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= 4'b0000;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule