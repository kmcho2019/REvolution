module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;

// Shift register with clock gating
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// Binary decoder
wire [7:0] decoder_out;
always @(*) begin
    case ({A, B, C})
        3'b000: decoder_out = 8'b10000000;
        3'b001: decoder_out = 8'b01000000;
        3'b010: decoder_out = 8'b00100000;
        3'b011: decoder_out = 8'b00010000;
        3'b100: decoder_out = 8'b00001000;
        3'b101: decoder_out = 8'b00000100;
        3'b110: decoder_out = 8'b00000010;
        3'b111: decoder_out = 8'b00000001;
        default: decoder_out = 8'b00000000;
    endcase
end

// Output logic using AND gates and OR gate
always @(*) begin
    wire [7:0] and_out;
    for (genvar i = 0; i < 8; i++) begin
        assign and_out[i] = Q[i] & decoder_out[i];
    end
    assign Z = |and_out;
end

endmodule