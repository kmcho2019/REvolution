module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Binary encoding for the states
logic [1:0] state, next_state;

// Asynchronous reset
always @(posedge RST) begin
    state <= 2'b00;
    MATCH <= 1'b0;
end

// Synchronous logic
always_ff @(posedge CLK) begin
    if (RST) begin
        state <= 2'b00;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= (state == 2'b11 && IN) ? 1'b1 : 1'b0;
    end
end

// Combinational logic
assign next_state = (RST) ? 2'b00 :
                    (state == 2'b00 && IN) ? 2'b01 :
                    (state == 2'b01 && ~IN) ? 2'b10 :
                    (state == 2'b10 && ~IN) ? 2'b10 :
                    (state == 2'b10 && IN) ? 2'b11 :
                    (state == 2'b11 && IN) ? 2'b00 :
                    state;

endmodule