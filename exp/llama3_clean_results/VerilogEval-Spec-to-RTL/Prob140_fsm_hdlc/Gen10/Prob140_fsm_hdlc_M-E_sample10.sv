module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] ones_count; // Counter for consecutive ones
reg [1:0] zeros_count; // Counter for consecutive zeros after five ones
reg flag_reg; // Flag to indicate start or end of frame
reg disc_reg; // Discard signal
reg err_reg; // Error signal (seven or more consecutive ones)

always @(posedge clk) begin
    if (reset) begin
        ones_count <= 0;
        zeros_count <= 0;
        flag_reg <= 0;
        disc_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            ones_count <= ones_count + 1;
            zeros_count <= 0;

            if (ones_count >= 7) begin
                err_reg <= 1;
            end
        end else begin
            if (ones_count >= 5 && ones_count < 7) begin
                zeros_count <= zeros_count + 1;

                if (zeros_count == 1) begin
                    if (ones_count == 6) begin
                        flag_reg <= 1;
                    end else begin
                        disc_reg <= 1;
                    end
                end
            end

            ones_count <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule