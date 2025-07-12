module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state;
reg [1:0] counter;
reg shift_ena_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b01;  // SHIFT state
        counter <= 2'd0;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            2'b01: begin  // SHIFT state
                counter <= counter + 1;
                if (counter == 4'd3) begin
                    state <= 2'b00;  // IDLE state
                    shift_ena_reg <= 1'b0;
                end
            end
            2'b00: begin  // IDLE state
                counter <= 2'd0;
            end
            default: state <= 2'b00;  // default to IDLE state
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule