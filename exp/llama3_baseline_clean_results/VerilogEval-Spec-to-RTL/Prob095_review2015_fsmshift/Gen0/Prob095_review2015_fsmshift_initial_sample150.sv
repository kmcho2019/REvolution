module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter;
reg [1:0] state; // 0: IDLE, 1: SHIFT_ENABLE, 2-3: Don't care
localparam IDLE = 2'b00;
localparam SHIFT_ENABLE = 2'b01;

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        shift_ena <= 1'b1;
        counter <= 2'b00;
        state <= SHIFT_ENABLE;
    end else begin
        case (state)
            SHIFT_ENABLE: begin
                if (counter == 4'b100) begin // 4 clock cycles have passed
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            IDLE: begin
                // Do nothing
            end
            default: begin
                // Do nothing
            end
        endcase
    end
end

endmodule