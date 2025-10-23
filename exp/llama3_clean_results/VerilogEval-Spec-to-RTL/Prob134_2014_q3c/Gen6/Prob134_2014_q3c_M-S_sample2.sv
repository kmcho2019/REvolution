module TopModule(
    input  clk,
    input  rst_n, // Asynchronous reset
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

logic [2:0] currentState, nextState;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        currentState <= 3'b000;
    end else begin
        currentState <= nextState;
    end
end

always_comb begin
    case (y)
        3'b000: nextState = x ? 3'b001 : 3'b000;
        3'b001: nextState = x ? 3'b100 : 3'b001;
        3'b010: nextState = x ? 3'b001 : 3'b010;
        3'b011: nextState = x ? 3'b010 : 3'b001;
        3'b100: nextState = x ? 3'b100 : 3'b011;
        default: nextState = 3'b000;
    endcase
end

assign Y0 = (currentState == 3'b011 || currentState == 3'b100) ? 1'b1 : 1'b0;
assign z = (currentState == 3'b011 || currentState == 3'b100) ? 1'b1 : 1'b0;

endmodule