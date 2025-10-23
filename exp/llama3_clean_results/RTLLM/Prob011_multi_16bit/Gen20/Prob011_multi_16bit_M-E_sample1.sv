module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// 4-bit multiplier blocks
wire [7:0] mul0, mul1, mul2, mul3;

four_bit_multiplier u0(.a(ain[3:0]), .b(bin), .out(mul0));
four_bit_multiplier u1(.a(ain[7:4]), .b(bin), .out(mul1));
four_bit_multiplier u2(.a(ain[11:8]), .b(bin), .out(mul2));
four_bit_multiplier u3(.a(ain[15:12]), .b(bin), .out(mul3));

// Control unit and accumulator
reg [31:0] acc;
reg [1:0] state;
always @(posedge clk) begin
    if (!rst_n) begin
        acc <= 32'd0;
        state <= 2'd0;
        done <= 1'b0;
    end else begin
        case (state)
            2'd0: begin
                if (start) begin
                    acc <= mul0;
                    state <= 2'd1;
                end
            end
            2'd1: begin
                acc <= acc + (mul1 << 4);
                state <= 2'd2;
            end
            2'd2: begin
                acc <= acc + (mul2 << 8);
                state <= 2'd3;
            end
            2'd3: begin
                acc <= acc + (mul3 << 12);
                done <= 1'b1;
                state <= 2'd0;
            end
        endcase
    end
end

assign yout = acc;

// 4-bit multiplier module
module four_bit_multiplier(
    input [3:0] a,
    input [15:0] b,
    output [7:0] out
);
    reg [7:0] temp;
    always @(*) begin
        temp = a * b;
    end
    assign out = temp;
endmodule

endmodule