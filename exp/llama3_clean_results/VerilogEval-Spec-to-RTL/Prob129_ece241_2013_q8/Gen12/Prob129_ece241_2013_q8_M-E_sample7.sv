module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] seq1_cnt;
reg [1:0] seq10_cnt;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        seq1_cnt <= 2'b00;
        seq10_cnt <= 2'b00;
        z <= 1'b0;
    end else begin
        if (x) begin
            if (seq10_cnt == 2'b01) begin
                z <= 1'b1;
            end else if (seq1_cnt == 2'b01) begin
                seq10_cnt <= seq10_cnt + 1;
                seq1_cnt <= 2'b00;
            end else begin
                seq1_cnt <= seq1_cnt + 1;
            end
        end else if (seq1_cnt != 2'b00) begin
            seq10_cnt <= seq10_cnt + 1;
            seq1_cnt <= 2'b00;
        end else begin
            seq10_cnt <= 2'b00;
        end
        if (seq10_cnt == 2'b10 || seq1_cnt == 2'b10) begin
            seq10_cnt <= 2'b00;
            seq1_cnt <= 2'b00;
            z <= 1'b0;
        end
    end
end

endmodule