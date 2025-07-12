module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] curr_state;
reg [2:0] next_state;

always_ff @(posedge clk) begin
    curr_state <= next_state;
end

always_comb begin
    case(curr_state)
        3'b000: next_state = x ? 3'b001 : 3'b000;
        3'b001: next_state = x ? 3'b100 : 3'b001;
        3'b010: next_state = x ? 3'b001 : 3'b010;
        3'b011: next_state = x ? 3'b010 : 3'b001;
        3'b100: next_state = x ? 3'b100 : 3'b011;
        default: next_state = 3'b000; // default to 000 if current state is unknown
    endcase
end

assign Y0 = next_state[0];
assign z = (curr_state == 3'b011 || curr_state == 3'b100);

endmodule