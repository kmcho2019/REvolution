module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: SHIFT2, 3: SHIFT3
reg [1:0] count; // counter for the number of clock cycles in the SHIFT state

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1;
        state <= 2'b01;
        count <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                shift_ena <= 1'b0;
                state <= 2'b00;
            end
            2'b01: begin // SHIFT state
                shift_ena <= 1'b1;
                if (count == 2'b11) begin
                    state <= 2'b00;
                    count <= 2'b00;
                end else begin
                    count <= count + 1;
                end
            end
            default: begin
                shift_ena <= 1'b0;
                state <= 2'b00;
            end
        endcase
    end
end

endmodule