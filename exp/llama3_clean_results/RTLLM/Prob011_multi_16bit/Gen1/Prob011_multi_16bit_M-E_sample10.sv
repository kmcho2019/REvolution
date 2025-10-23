module multi_16bit (
    input  clk, 
    input  rst_n, 
    input  start, 
    input  [15:0] ain, 
    input  [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [1:0] i;
reg done_r;

assign yout = yout_r;
assign done = done_r;

// Divide the multiplicand into 4-bit segments
wire [3:0] seg1 = ain[3:0];
wire [3:0] seg2 = ain[7:4];
wire [3:0] seg3 = ain[11:8];
wire [3:0] seg4 = ain[15:12];

// Perform shift and accumulate operation for each segment in parallel
reg [31:0] seg1_out;
reg [31:0] seg2_out;
reg [31:0] seg3_out;
reg [31:0] seg4_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
        seg1_out <= 0;
        seg2_out <= 0;
        seg3_out <= 0;
        seg4_out <= 0;
    end else begin
        if (start) begin
            areg <= ain;
            breg <= bin;
            if (i == 0) begin
                seg1_out <= (seg1[0] == 1) ? (breg << 0) : 0;
                seg2_out <= (seg2[0] == 1) ? (breg << 4) : 0;
                seg3_out <= (seg3[0] == 1) ? (breg << 8) : 0;
                seg4_out <= (seg4[0] == 1) ? (breg << 12) : 0;
            end else if (i == 1) begin
                seg1_out <= seg1_out + ((seg1[1] == 1) ? (breg << 1) : 0);
                seg2_out <= seg2_out + ((seg2[1] == 1) ? (breg << 5) : 0);
                seg3_out <= seg3_out + ((seg3[1] == 1) ? (breg << 9) : 0);
                seg4_out <= seg4_out + ((seg4[1] == 1) ? (breg << 13) : 0);
            end else if (i == 2) begin
                seg1_out <= seg1_out + ((seg1[2] == 1) ? (breg << 2) : 0);
                seg2_out <= seg2_out + ((seg2[2] == 1) ? (breg << 6) : 0);
                seg3_out <= seg3_out + ((seg3[2] == 1) ? (breg << 10) : 0);
                seg4_out <= seg4_out + ((seg4[2] == 1) ? (breg << 14) : 0);
            end else if (i == 3) begin
                seg1_out <= seg1_out + ((seg1[3] == 1) ? (breg << 3) : 0);
                seg2_out <= seg2_out + ((seg2[3] == 1) ? (breg << 7) : 0);
                seg3_out <= seg3_out + ((seg3[3] == 1) ? (breg << 11) : 0);
                seg4_out <= seg4_out + ((seg4[3] == 1) ? (breg << 15) : 0);
            end
            yout_r <= seg1_out + seg2_out + seg3_out + seg4_out;
            if (i == 3) begin
                done_r <= 1;
            end
            i <= i + 1;
        end else begin
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            done_r <= 0;
            seg1_out <= 0;
            seg2_out <= 0;
            seg3_out <= 0;
            seg4_out <= 0;
            i <= 0;
        end
    end
end

endmodule