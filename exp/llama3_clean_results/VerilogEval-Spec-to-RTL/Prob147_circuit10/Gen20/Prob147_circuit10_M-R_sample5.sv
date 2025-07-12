module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case ({a, b})
        2'b00: state <= 1'b0;
        2'b01: state <= 1'b1;
        2'b10: state <= state;
        2'b11: 
            if (state == 1'b1) 
                state <= 1'b0;
            else 
                state <= state;
        default: state <= state;
    endcase
end

assign q = (state == 1'b1) || (a && ~b);

endmodule