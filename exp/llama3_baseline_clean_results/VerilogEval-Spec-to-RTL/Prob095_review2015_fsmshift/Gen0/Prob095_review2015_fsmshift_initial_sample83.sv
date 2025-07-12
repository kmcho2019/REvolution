module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state;
reg [1:0] count;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01;  // shifting state
        count <= 2'b00;  // reset counter
        shift_ena_reg <= 1'b1;  // assert shift_ena
    end else begin
        case (state)
            2'b01: begin  // shifting state
                if (count == 2'b11) begin  // 4 clock cycles
                    state <= 2'b00;  // idle state
                    shift_ena_reg <= 1'b0;  // deassert shift_ena
                end else begin
                    count <= count + 1'b1;  // increment counter
                end
            end
            2'b00: begin  // idle state
                // do nothing
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule