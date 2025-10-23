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

// Initialize the shift register
initial Q = 8'b0;

always @(posedge clk) begin
    if (enable) begin
        // Shift the bits to the right
        Q <= {S, Q[7:1]};
    end else begin
        // Hold the current state
        Q <= Q;
    end
end

// 3-to-8 line decoder (multiplexer)
wire [7:0] Z_sources;
assign Z_sources = Q;

always @(*) begin
    case ({A, B, C})
        3'b000: Z = Z_sources[0];
        3'b001: Z = Z_sources[1];
        3'b010: Z = Z_sources[2];
        3'b011: Z = Z_sources[3];
        3'b100: Z = Z_sources[4];
        3'b101: Z = Z_sources[5];
        3'b110: Z = Z_sources[6];
        3'b111: Z = Z_sources[7];
        default: Z = 1'bx; // Don't care
    endcase
end

endmodule