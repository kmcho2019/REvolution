module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

// Define the outputs of the 8-bit shift register
reg [7:0] Q;

// Implement the 8-bit shift register
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// Define the multiplexer inputs and outputs
wire [7:0] mux_inputs;
assign mux_inputs = Q;

// Define the multiplexer select signals
wire [2:0] select;
assign select = {A, B, C};

// Implement the multiplexer tree
always @(*) begin
    case (select)
        3'b000: Z = mux_inputs[0];
        3'b001: Z = mux_inputs[1];
        3'b010: Z = mux_inputs[2];
        3'b011: Z = mux_inputs[3];
        3'b100: Z = mux_inputs[4];
        3'b101: Z = mux_inputs[5];
        3'b110: Z = mux_inputs[6];
        3'b111: Z = mux_inputs[7];
        default: Z = 1'bx;
    endcase
end

endmodule