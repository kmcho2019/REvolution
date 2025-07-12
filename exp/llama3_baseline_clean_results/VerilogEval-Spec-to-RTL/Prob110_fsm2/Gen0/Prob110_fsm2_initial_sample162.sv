module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [1:0] state;  // 0 - OFF, 1 - ON
reg [1:0] next_state;

always @(*) begin
    case(state)
        0:  // OFF state
            if(j)
                next_state = 1;  // move to ON state
            else
                next_state = 0;  // stay in OFF state
        1:  // ON state
            if(k)
                next_state = 0;  // move to OFF state
            else
                next_state = 1;  // stay in ON state
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0;  // asynchronous reset to OFF state
    end else begin
        state <= next_state;
    end
end

assign out = (state == 1);  // output is 1 in ON state

endmodule