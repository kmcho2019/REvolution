// Novel architectural implementation using a shift register
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;
    reg [2:0] shift_counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
            shift_counter <= 3'b0;
        end else begin
            if (shift_counter == 3'b111) begin
                // Reset counter when full shift is completed
                shift_counter <= 3'b0;
            end else begin
                // Shift data into the register
                q_reg <= {q_reg[6:0], d[shift_counter]};
                shift_counter <= shift_counter + 1'b1;
            end
        end
    end

    assign q = q_reg;

endmodule