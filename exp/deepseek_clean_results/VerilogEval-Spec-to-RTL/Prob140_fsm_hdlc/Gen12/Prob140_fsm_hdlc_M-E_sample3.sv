module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;
    wire disc_match = (shift_reg[6:0] == 7'b0111110);
    wire flag_match = (shift_reg[6:0] == 7'b0111111);
    wire err_match  = (shift_reg[6] & (&shift_reg[5:0] & in); // 0111111 followed by another 1

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};
            
            // Register outputs
            disc <= disc_match;
            flag <= flag_match && !in; // Flag only if next bit is 0
            err <= err_match;
        end
    end

endmodule