module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

parameter OFF = 0, ON = 1;
reg [0:0] state;

always @(posedge areset or negedge clk) begin
    if (areset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: if (j) state <= ON; else state <= OFF;
            ON:  if (k) state <= OFF; else state <= ON;
        endcase
    end
end

assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule