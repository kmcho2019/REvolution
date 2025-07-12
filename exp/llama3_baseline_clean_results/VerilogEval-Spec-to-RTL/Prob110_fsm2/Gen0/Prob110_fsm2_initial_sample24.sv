module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // current state: 0 for OFF, 1 for ON
reg [0:0] next_state; // next state

always @(*) begin
    case(state)
        0: begin // OFF state
            if(j) next_state = 1; // j=1, transition to ON
            else next_state = 0; // j=0, stay in OFF
        end
        1: begin // ON state
            if(k) next_state = 0; // k=1, transition to OFF
            else next_state = 1; // k=0, stay in ON
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= 0; // asynchronous reset to OFF state
    else state <= next_state;
end

assign out = state; // output is the current state (0 for OFF, 1 for ON)

endmodule