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

    // Shift register with enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S}; // Shift right: new bit at Q[0]
        end
    end

    // Multiplexer to select Z based on ABC
    // ABC form a 3-bit index: A is MSB, C is LSB
    wire [2:0] addr = {A,B,C};

    always @(*) begin
        case (addr)
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default: Z = 1'b0;
        endcase
    end

endmodule