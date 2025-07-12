module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// State register with asynchronous reset
reg state;
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= 1'b0;
    else begin
        case({j, k})
            2'b01: state <= 1'b1;
            2'b00: state <= 1'b0;
            2'b10: state <= 1'b0;
            2'b11: state <= 1'b1;
        endcase
    end
end

// Output logic
assign out = state;

endmodule