module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    reg [1:0] state;
    
    always @(posedge clk, posedge areset) begin
        if (areset) state <= 2'b00;
        else case (state)
            2'b00: state <= ~ground ? 2'b10 : bump_left ? 2'b01 : 2'b00;
            2'b01: state <= ~ground ? 2'b11 : bump_right ? 2'b00 : 2'b01;
            2'b10: state <= ground ? 2'b00 : 2'b10;
            2'b11: state <= ground ? 2'b01 : 2'b11;
        endcase
    end
    
    assign {walk_left, walk_right} = state[1] ? 2'b00 : {state == 2'b00, state == 2'b01};
    assign aaah = state[1];
endmodule