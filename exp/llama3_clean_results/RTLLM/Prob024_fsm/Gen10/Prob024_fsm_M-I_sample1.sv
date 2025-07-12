module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// One-hot encoding for the state variable
logic [4:0] state;

// Synchronous reset
always @(posedge CLK) begin
    if (RST) begin
        state <= 5'b00001;
        MATCH <= 1'b0;
    end else begin
        case (1'b1)
            state[0]: begin // State 0
                if (IN) begin
                    state <= 5'b00010;
                end else begin
                    state <= 5'b00001;
                end
            end
            state[1]: begin // State 1
                if (!IN) begin
                    state <= 5'b00100;
                end else begin
                    state <= 5'b00001;
                end
            end
            state[2]: begin // State 2
                if (!IN) begin
                    state <= 5'b01000;
                end else begin
                    state <= 5'b00001;
                end
            end
            state[3]: begin // State 3
                if (IN) begin
                    state <= 5'b10000;
                end else begin
                    state <= 5'b00001;
                end
            end
            state[4]: begin // State 4
                if (IN) begin
                    MATCH <= 1'b1;
                    state <= 5'b00001;
                end else begin
                    state <= 5'b00001;
                    MATCH <= 1'b0;
                end
            end
        endcase
    end
end

endmodule