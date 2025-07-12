module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Segmenting the inputs
wire [3:0] a3, a2, a1, a0;
wire [3:0] b3, b2, b1, b0;

assign a3 = ain[15:12];
assign a2 = ain[11:8];
assign a1 = ain[7:4];
assign a0 = ain[3:0];

assign b3 = bin[15:12];
assign b2 = bin[11:8];
assign b1 = bin[7:4];
assign b0 = bin[3:0];

// Partial product generation
wire [7:0] pp00, pp01, pp02, pp03;
wire [7:0] pp10, pp11, pp12, pp13;
wire [7:0] pp20, pp21, pp22, pp23;
wire [7:0] pp30, pp31, pp32, pp33;

multi_4bit u_pp00(.a(a0), .b(b0), .out(pp00));
multi_4bit u_pp01(.a(a0), .b(b1), .out(pp01));
multi_4bit u_pp02(.a(a0), .b(b2), .out(pp02));
multi_4bit u_pp03(.a(a0), .b(b3), .out(pp03));

multi_4bit u_pp10(.a(a1), .b(b0), .out(pp10));
multi_4bit u_pp11(.a(a1), .b(b1), .out(pp11));
multi_4bit u_pp12(.a(a1), .b(b2), .out(pp12));
multi_4bit u_pp13(.a(a1), .b(b3), .out(pp13));

multi_4bit u_pp20(.a(a2), .b(b0), .out(pp20));
multi_4bit u_pp21(.a(a2), .b(b1), .out(pp21));
multi_4bit u_pp22(.a(a2), .b(b2), .out(pp22));
multi_4bit u_pp23(.a(a2), .b(b3), .out(pp23));

multi_4bit u_pp30(.a(a3), .b(b0), .out(pp30));
multi_4bit u_pp31(.a(a3), .b(b1), .out(pp31));
multi_4bit u_pp32(.a(a3), .b(b2), .out(pp32));
multi_4bit u_pp33(.a(a3), .b(b3), .out(pp33));

// Alignment and summation
reg [31:0] yout_r;

always @(posedge clk) begin
    if (!rst_n) begin
        yout_r <= 32'd0;
    end else if (start) begin
        // Alignment and summation logic
        yout_r <= pp00 + (pp01 << 4) + (pp02 << 8) + (pp03 << 12) +
                   (pp10 << 4) + (pp11 << 8) + (pp12 << 12) + (pp13 << 16) +
                   (pp20 << 8) + (pp21 << 12) + (pp22 << 16) + (pp23 << 20) +
                   (pp30 << 12) + (pp31 << 16) + (pp32 << 20) + (pp33 << 24);
    end
end

assign yout = yout_r;
assign done = (yout_r != 0);

// 4-bit multiplier module
module multi_4bit(
    input [3:0] a,
    input [3:0] b,
    output [7:0] out
);

assign out = a * b;

endmodule

endmodule