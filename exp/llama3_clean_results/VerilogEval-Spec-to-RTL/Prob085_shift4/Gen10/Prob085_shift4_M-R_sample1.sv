module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

// Combinational logic to determine the next state
wire [3:0] next_state;
assign next_state = (load) ? data : (ena) ? {1'b0, q_reg[3:1]} : q_reg;

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule