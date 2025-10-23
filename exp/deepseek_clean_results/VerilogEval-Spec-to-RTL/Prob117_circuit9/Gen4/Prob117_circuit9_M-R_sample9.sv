module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] state = 3'b100;
wire [2:0] next_state;

assign next_state = a ? state : 
                   (state == 3'b110) ? 3'b000 : 
                   state + 1;

assign q = state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule