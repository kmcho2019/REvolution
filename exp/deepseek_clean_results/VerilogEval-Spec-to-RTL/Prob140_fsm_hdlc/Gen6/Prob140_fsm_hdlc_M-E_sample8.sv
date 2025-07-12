module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;
    wire [7:0] extended_pattern = {shift_reg, in};

    // Shift register update
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            shift_reg <= {shift_reg[5:0], in};
            
            // Pattern detection with edge triggering
            disc <= (shift_reg == 7'b0111110);
            flag <= (extended_pattern == 8'b01111110);
            err <= (extended_pattern == 8'b01111111);
        end
    end

endmodule