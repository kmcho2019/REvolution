module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] ones_counter; // Counter for consecutive 1s
reg       disc_flag;    // Flag to indicate 'disc' signal
reg       flag_flag;    // Flag to indicate 'flag' signal
reg       err_flag;     // Flag to indicate 'err' signal
reg       zero_after_five_ones; // Flag to indicate 0 after 5 consecutive 1s

always @(posedge clk) begin
    if (reset) begin
        ones_counter <= 3'b000;
        disc_flag <= 1'b0;
        flag_flag <= 1'b0;
        err_flag <= 1'b0;
        zero_after_five_ones <= 1'b0;
    end else begin
        if (in) begin
            ones_counter <= ones_counter + 1;
            if (ones_counter == 6) begin
                if (~in) flag_flag <= 1'b1;
                else err_flag <= 1'b1;
            end
            disc_flag <= 1'b0;
        end else begin
            if (ones_counter == 5) zero_after_five_ones <= 1'b1;
            if (zero_after_five_ones) disc_flag <= 1'b1;
            ones_counter <= 3'b000;
            zero_after_five_ones <= 1'b0;
            flag_flag <= 1'b0;
            err_flag <= 1'b0;
        end
    end
end

assign disc = disc_flag;
assign flag = flag_flag;
assign err = err_flag;

endmodule