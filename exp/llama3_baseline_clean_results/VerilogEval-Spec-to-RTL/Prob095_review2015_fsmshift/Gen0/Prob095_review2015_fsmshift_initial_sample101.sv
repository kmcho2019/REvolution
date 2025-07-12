module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: done
reg [1:0] count; // counter for 4 cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // start shifting on reset
        count <= 0; // reset counter
    end else begin
        case (state)
            1: begin // shifting
                if (count == 3) begin
                    state <= 2; // done shifting
                end else begin
                    count <= count + 1;
                end
            end
            2: begin // done
                // stay in this state forever
            end
            default: ; // idle state, do nothing
        endcase
    end
end

assign shift_ena = (state == 1); // enable shift register when shifting

endmodule