module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// State machine encoding
logic [3:0] state, next_state;

// Asynchronous reset
assign state = (RST) ? 4'b0000 : state;

// Synchronous logic
always_ff @(posedge CLK) begin
    if (RST) begin
        state <= 4'b0000;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
assign next_state = (state == 4'b0000 && IN) ? 4'b0001 :
                    (state == 4'b0001 && ~IN) ? 4'b0010 :
                    (state == 4'b0010 && ~IN) ? 4'b0010 :
                    (state == 4'b0010 && IN) ? 4'b0100 :
                    (state == 4'b0100 && IN) ? 4'b1000 :
                    4'b0000;

assign MATCH = (state == 4'b1000 && IN);

endmodule