module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// State variable to keep track of the current state
logic [2:0] state;

// Next state logic
logic [2:0] next_state;

// Output logic
logic match_out;

// Define next state logic
assign next_state = (state == 3'b000 && IN) ? 3'b001 :
                    (state == 3'b001 && !IN) ? 3'b010 :
                    (state == 3'b010 && !IN) ? 3'b011 :
                    (state == 3'b011 && IN) ? 3'b100 :
                    (state == 3'b100 && IN) ? 3'b000 :
                    3'b000;

// Define output logic
assign match_out = (state == 3'b100 && IN) ? 1'b1 : 1'b0;

// Asynchronous reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match_out;
    end
end

endmodule