module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [5:0] seq; // Sequence register to track last 6 bits
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        seq <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        seq <= {seq[4:0], in};

        // Check for 7 or more consecutive ones (error)
        if (seq == 6'b111111) begin
            err_reg <= 1;
        end
        // Check for flag sequence (01111110)
        else if (seq == 6'b01111110) begin
            flag_reg <= 1;
        end
        // Check for discard sequence (01111110 followed by 0)
        else if (seq == 6'b01111110 && ~in) begin
            disc_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule