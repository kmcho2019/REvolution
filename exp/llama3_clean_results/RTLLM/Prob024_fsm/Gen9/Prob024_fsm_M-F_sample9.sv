module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// State variable to keep track of the current state
logic [2:0] state;

// Asynchronous reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // State 0
                if (IN) begin
                    state <= 3'b001;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin // State 1
                if (!IN) begin
                    state <= 3'b010;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b010: begin // State 2
                if (!IN) begin
                    state <= 3'b011;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b011: begin // State 3
                if (IN) begin
                    state <= 3'b100;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b100: begin // State 4
                if (IN) begin
                    MATCH <= 1'b1;
                    state <= 3'b000;
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