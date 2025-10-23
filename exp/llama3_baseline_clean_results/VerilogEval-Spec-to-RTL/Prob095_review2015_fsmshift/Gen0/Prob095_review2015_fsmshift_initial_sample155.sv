module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2-3: countdown
reg [1:0] count; // counter for 4 clock cycles

always @ (posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1;
        state <= 2'd1; // start shifting
        count <= 2'd0; // reset counter
    end else begin
        case (state)
            2'd1: begin
                shift_ena <= 1'b1; // shifting
                if (count == 2'd3) begin // 4 cycles
                    state <= 2'd0; // idle
                    shift_ena <= 1'b0;
                end else begin
                    count <= count + 1;
                end
            end
            2'd0: begin
                shift_ena <= 1'b0; // idle
            end
        endcase
    end
end

endmodule