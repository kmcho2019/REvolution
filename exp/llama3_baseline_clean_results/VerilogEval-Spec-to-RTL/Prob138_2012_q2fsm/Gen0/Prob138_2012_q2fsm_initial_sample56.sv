module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// State table (combinational logic)
always @(*) begin
    case(current_state)
        3'b000: next_state = (w)? 3'b001 : 3'b000;
        3'b001: next_state = (w)? 3'b010 : 3'b011;
        3'b010: next_state = (w)? 3'b100 : 3'b011;
        3'b011: next_state = (w)? 3'b101 : 3'b000;
        3'b100: next_state = (w)? 3'b100 : 3'b011;
        3'b101: next_state = (w)? 3'b010 : 3'b011;
        default: next_state = 3'b000;
    endcase
end

// State flip-flops (sequential logic)
always @(posedge clk) begin
    if(reset) begin
        current_state <= 3'b000;
    end else begin
        current_state <= next_state;
    end
end

// Output z
assign z = (current_state == 3'b100) || (current_state == 3'b101);

endmodule