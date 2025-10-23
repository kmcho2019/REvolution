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

    // 8-bit shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            // Shift the bits only when enable is high
            Q[7:1] <= Q[6:0];
            Q[0] <= S;
        end else begin
            // Keep the register values unchanged when enable is low
            Q <= Q;
        end
    end

    // Combinational logic for output Z based on ABC
    always @(*) begin
        case ({A, B, C})
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default: Z = 1'bx; // Handle undefined cases
        endcase
    end

endmodule