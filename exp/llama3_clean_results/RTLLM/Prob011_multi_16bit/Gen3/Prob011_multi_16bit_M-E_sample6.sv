module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [31:0] yout_r;
reg [3:0] i;
reg done_r;
reg [3:0] ain_seg1, ain_seg2, ain_seg3, ain_seg4;
reg [3:0] bin_seg1, bin_seg2, bin_seg3, bin_seg4;
reg [7:0] prod1, prod2, prod3, prod4;
wire [7:0] partial_prod1, partial_prod2, partial_prod3, partial_prod4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
        done_r <= 0;
        yout_r <= 0;
    end else if (start && (i == 0)) begin
        ain_seg1 <= ain[3:0];
        ain_seg2 <= ain[7:4];
        ain_seg3 <= ain[11:8];
        ain_seg4 <= ain[15:12];
        bin_seg1 <= bin[3:0];
        bin_seg2 <= bin[7:4];
        bin_seg3 <= bin[11:8];
        bin_seg4 <= bin[15:12];
        i <= 1;
    end else if (start && (i == 1)) begin
        prod1 <= ain_seg1 * bin_seg1;
        prod2 <= ain_seg2 * bin_seg2;
        prod3 <= ain_seg3 * bin_seg3;
        prod4 <= ain_seg4 * bin_seg4;
        i <= 2;
    end else if (start && (i == 2)) begin
        partial_prod1 <= prod1;
        partial_prod2 <= prod2 + (prod1 << 4);
        partial_prod3 <= prod3 + (prod2 << 4);
        partial_prod4 <= prod4 + (prod3 << 4);
        yout_r <= {partial_prod4, partial_prod3, partial_prod2, partial_prod1};
        done_r <= 1;
        i <= 3;
    end else if (start && (i == 3)) begin
        done_r <= 0;
        i <= 0;
    end else if (!start) begin
        i <= 0;
        done_r <= 0;
        yout_r <= 0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule