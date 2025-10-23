module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Combinational logic for next state
assign next_state = (current_state == 3'b000) ? (x ? 3'b001 : 3'b000) :
                     (current_state == 3'b001) ? (x ? 3'b100 : 3'b001) :
                     (current_state == 3'b010) ? (x ? 3'b001 : 3'b010) :
                     (current_state == 3'b011) ? (x ? 3'b010 : 3'b001) :
                     (current_state == 3'b100) ? (x ? 3'b100 : 3'b011) :
                     3'b000;

// Output logic
always @ (current_state or x) begin
    case (current_state)
        3'b000: z = (x) ? 1'b0 : 1'b0;
        3'b001: z = (x) ? 1'b0 : 1'b0;
        3'b010: z = (x) ? 1'b0 : 1'b0;
        3'b011: z = (x) ? 1'b1 : 1'b1;
        3'b100: z = (x) ? 1'b1 : 1'b1;
        default: z = 1'b0;
    endcase
end

assign Y0 = next_state[0];

endmodule