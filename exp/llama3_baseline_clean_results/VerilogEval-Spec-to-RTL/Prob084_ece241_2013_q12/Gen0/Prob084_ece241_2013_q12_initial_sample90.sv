module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q <= {S, Q[7:1]};
    end
end

wire [7:0] mux_input;
assign mux_input = {Q[7], Q[6], Q[5], Q[4], Q[3], Q[2], Q[1], Q[0]};

wire [2:0] select_line;
assign select_line = {A, B, C};

always @(select_line or mux_input) begin
    case (select_line)
        3'b000: Z <= mux_input[0];
        3'b001: Z <= mux_input[1];
        3'b010: Z <= mux_input[2];
        3'b011: Z <= mux_input[3];
        3'b100: Z <= mux_input[4];
        3'b101: Z <= mux_input[5];
        3'b110: Z <= mux_input[6];
        3'b111: Z <= mux_input[7];
        default: Z <= 1'bx;
    endcase
end

endmodule