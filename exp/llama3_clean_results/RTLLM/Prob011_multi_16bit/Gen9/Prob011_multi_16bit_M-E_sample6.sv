module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

// Segment dividers
wire [3:0] a_seg1 = ain[3:0];
wire [3:0] a_seg2 = ain[7:4];
wire [3:0] a_seg3 = ain[11:8];
wire [3:0] a_seg4 = ain[15:12];

wire [3:0] b_seg1 = bin[3:0];
wire [3:0] b_seg2 = bin[7:4];
wire [3:0] b_seg3 = bin[11:8];
wire [3:0] b_seg4 = bin[15:12];

// 4x4 multipliers
wire [7:0] pp1;
wire [7:0] pp2;
wire [7:0] pp3;
wire [7:0] pp4;
wire [7:0] pp5;
wire [7:0] pp6;
wire [7:0] pp7;
wire [7:0] pp8;
wire [7:0] pp9;
wire [7:0] pp10;
wire [7:0] pp11;
wire [7:0] pp12;
wire [7:0] pp13;
wire [7:0] pp14;
wire [7:0] pp15;
wire [7:0] pp16;

// Instantiating 4x4 multipliers
multi_4x4 u1(.ain(a_seg1), .bin(b_seg1), .yout(pp1));
multi_4x4 u2(.ain(a_seg1), .bin(b_seg2), .yout(pp2));
multi_4x4 u3(.ain(a_seg1), .bin(b_seg3), .yout(pp3));
multi_4x4 u4(.ain(a_seg1), .bin(b_seg4), .yout(pp4));
multi_4x4 u5(.ain(a_seg2), .bin(b_seg1), .yout(pp5));
multi_4x4 u6(.ain(a_seg2), .bin(b_seg2), .yout(pp6));
multi_4x4 u7(.ain(a_seg2), .bin(b_seg3), .yout(pp7));
multi_4x4 u8(.ain(a_seg2), .bin(b_seg4), .yout(pp8));
multi_4x4 u9(.ain(a_seg3), .bin(b_seg1), .yout(pp9));
multi_4x4 u10(.ain(a_seg3), .bin(b_seg2), .yout(pp10));
multi_4x4 u11(.ain(a_seg3), .bin(b_seg3), .yout(pp11));
multi_4x4 u12(.ain(a_seg3), .bin(b_seg4), .yout(pp12));
multi_4x4 u13(.ain(a_seg4), .bin(b_seg1), .yout(pp13));
multi_4x4 u14(.ain(a_seg4), .bin(b_seg2), .yout(pp14));
multi_4x4 u15(.ain(a_seg4), .bin(b_seg3), .yout(pp15));
multi_4x4 u16(.ain(a_seg4), .bin(b_seg4), .yout(pp16));

// Partial product adders and shift logic
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        yout_r <= 0;
        i <= 0;
        done_r <= 0;
    end else begin
        if (start) begin
            if (i == 0) begin
                yout_r <= pp1;
                i <= 1;
            end else if (i == 1) begin
                yout_r <= yout_r + (pp2 << 4);
                i <= 2;
            end else if (i == 2) begin
                yout_r <= yout_r + (pp3 << 8);
                i <= 3;
            end else if (i == 3) begin
                yout_r <= yout_r + (pp4 << 12);
                i <= 4;
            end else if (i == 4) begin
                yout_r <= yout_r + (pp5 << 4);
                i <= 5;
            end else if (i == 5) begin
                yout_r <= yout_r + (pp6 << 8);
                i <= 6;
            end else if (i == 6) begin
                yout_r <= yout_r + (pp7 << 12);
                i <= 7;
            end else if (i == 7) begin
                yout_r <= yout_r + (pp8 << 16);
                i <= 8;
            end else if (i == 8) begin
                yout_r <= yout_r + (pp9 << 4);
                i <= 9;
            end else if (i == 9) begin
                yout_r <= yout_r + (pp10 << 8);
                i <= 10;
            end else if (i == 10) begin
                yout_r <= yout_r + (pp11 << 12);
                i <= 11;
            end else if (i == 11) begin
                yout_r <= yout_r + (pp12 << 16);
                i <= 12;
            end else if (i == 12) begin
                yout_r <= yout_r + (pp13 << 4);
                i <= 13;
            end else if (i == 13) begin
                yout_r <= yout_r + (pp14 << 8);
                i <= 14;
            end else if (i == 14) begin
                yout_r <= yout_r + (pp15 << 12);
                i <= 15;
            end else if (i == 15) begin
                yout_r <= yout_r + (pp16 << 16);
                done_r <= 1;
                i <= 0;
            end
        end else begin
            yout_r <= 0;
            i <= 0;
            done_r <= 0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule

module multi_4x4(
    input [3:0] ain, 
    input [3:0] bin, 
    output [7:0] yout
);

assign yout = ain * bin;

endmodule