module TopModule (
    input clk,
    input resetn,
    input in,
    output reg out
);
    reg [3:0] shift_reg;
    reg clk_en;

    always @(*) begin
        // Enable shift only if input differs from last shifted out bit or during reset
        clk_en = (~resetn) | (in != shift_reg[0]);
    end

    always @(posedge clk) begin
        if (~resetn) begin
            shift_reg <= 4'b0000;
        end else if (clk_en) begin
            shift_reg <= {shift_reg[2:0], in};
        end
    end

    always @(posedge clk) begin
        // Output always follows MSB of shift_reg
        out <= shift_reg[3];
    end

endmodule