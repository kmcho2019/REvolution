module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg done_r;

// Divide the 16-bit multiplicand and multiplier into 4-bit segments
reg [3:0] aseg0, aseg1, aseg2, aseg3;
reg [3:0] bseg0, bseg1, bseg2, bseg3;

// Create a parallel multiplier array
reg [7:0] prod00, prod01, prod02, prod03;
reg [7:0] prod10, prod11, prod12, prod13;
reg [7:0] prod20, prod21, prod22, prod23;
reg [7:0] prod30, prod31, prod32, prod33;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        if (start) begin
            // Divide the 16-bit multiplicand and multiplier into 4-bit segments
            aseg0 <= ain[3:0];
            aseg1 <= ain[7:4];
            aseg2 <= ain[11:8];
            aseg3 <= ain[15:12];
            bseg0 <= bin[3:0];
            bseg1 <= bin[7:4];
            bseg2 <= bin[11:8];
            bseg3 <= bin[15:12];

            // Perform the multiplication operation using the parallel multiplier array
            prod00 <= aseg0 * bseg0;
            prod01 <= aseg0 * bseg1;
            prod02 <= aseg0 * bseg2;
            prod03 <= aseg0 * bseg3;
            prod10 <= aseg1 * bseg0;
            prod11 <= aseg1 * bseg1;
            prod12 <= aseg1 * bseg2;
            prod13 <= aseg1 * bseg3;
            prod20 <= aseg2 * bseg0;
            prod21 <= aseg2 * bseg1;
            prod22 <= aseg2 * bseg2;
            prod23 <= aseg2 * bseg3;
            prod30 <= aseg3 * bseg0;
            prod31 <= aseg3 * bseg1;
            prod32 <= aseg3 * bseg2;
            prod33 <= aseg3 * bseg3;

            // Accumulate the partial products
            yout_r <= prod00 + (prod01 << 4) + (prod02 << 8) + (prod03 << 12) +
                       (prod10 << 4) + (prod11 << 8) + (prod12 << 12) + (prod13 << 16) +
                       (prod20 << 8) + (prod21 << 12) + (prod22 << 16) + (prod23 << 20) +
                       (prod30 << 12) + (prod31 << 16) + (prod32 << 20) + (prod33 << 24);

            done_r <= 1;
        end else begin
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            done_r <= 0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule