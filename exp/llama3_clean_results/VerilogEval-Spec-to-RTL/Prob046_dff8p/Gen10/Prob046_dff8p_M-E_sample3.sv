module TopModule(
    input clk,
    input reset,
    input d,
    output [7:0] q
);

reg [7:0] shift_reg;
reg [2:0] counter;

always @(negedge clk) begin
    if (reset) begin
        // Load reset value (0x34) serially
        case (counter)
            3'd0: shift_reg <= {7'd0, 1'b0}; // MSB
            3'd1: shift_reg <= {shift_reg[6:0], 1'b0};
            3'd2: shift_reg <= {shift_reg[6:0], 1'b0};
            3'd3: shift_reg <= {shift_reg[6:0], 1'b0};
            3'd4: shift_reg <= {shift_reg[6:0], 1'b1};
            3'd5: shift_reg <= {shift_reg[6:0], 1'b1};
            3'd6: shift_reg <= {shift_reg[6:0], 1'b0};
            3'd7: shift_reg <= {shift_reg[6:0], 1'b0};
        endcase
        counter <= counter + 1;
        if (counter == 3'd7) begin
            counter <= 3'd0;
        end
    end else begin
        // Load input data serially
        shift_reg <= {shift_reg[6:0], d};
        counter <= counter + 1;
        if (counter == 3'd7) begin
            counter <= 3'd0;
        end
    end
end

assign q = shift_reg;

endmodule