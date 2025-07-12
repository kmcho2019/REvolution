module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: countdown
reg [1:0] count; // counter for 4 clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // shifting state
        count <= 0;
        shift_ena <= 1;
    end else begin
        case (state)
            1: begin // shifting state
                if (count < 3) begin
                    count <= count + 1;
                end else begin
                    state <= 0; // idle state
                    shift_ena <= 0;
                end
            end
            0: begin // idle state
                // do nothing, wait for reset
            end
            default: ;
        endcase
    end
end

endmodule