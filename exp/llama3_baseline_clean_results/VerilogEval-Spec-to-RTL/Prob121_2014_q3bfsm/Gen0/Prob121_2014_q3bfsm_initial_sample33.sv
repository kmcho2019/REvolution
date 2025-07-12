module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg output_z; // output z

// Combinational logic to determine next state
always @(*) begin
    case (y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000; // default to state 000
    endcase
end

// Combinational logic to determine output z
always @(*) begin
    case (y)
        3'b011: output_z = 1'b1;
        3'b100: output_z = 1'b1;
        default: output_z = 1'b0;
    endcase
end

// Sequential logic to update current state
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous reset
    end else begin
        y <= next_y;
    end
end

assign z = output_z; // assign output z

endmodule