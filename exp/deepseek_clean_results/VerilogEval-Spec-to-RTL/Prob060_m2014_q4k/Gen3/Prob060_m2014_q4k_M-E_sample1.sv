module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg [1:0] counter;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            counter <= 2'b0;
        end
        else begin
            shift_reg <= {shift_reg[2:0], in};
            counter <= counter + 1;
        end
    end

    assign out = shift_reg[counter];

endmodule