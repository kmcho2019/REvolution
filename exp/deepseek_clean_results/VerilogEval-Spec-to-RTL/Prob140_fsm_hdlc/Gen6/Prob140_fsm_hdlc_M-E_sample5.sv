module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;
    wire match_discard = (shift_reg[6:0] == 7'b0111110;
    wire match_flag = (shift_reg[6:0] == 7'b0111110) && !in;
    wire match_error = &shift_reg;  // All 1s

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            {disc, flag, err} <= 3'b0;
        end else begin
            // Update shift register
            shift_reg <= {shift_reg[5:0], in};

            // Set outputs for next cycle
            disc <= match_discard;
            flag <= match_flag;
            
            // Error persists until broken by 0
            if (match_error)
                err <= 1'b1;
            else if (!in)
                err <= 1'b0;
        end
    end

endmodule