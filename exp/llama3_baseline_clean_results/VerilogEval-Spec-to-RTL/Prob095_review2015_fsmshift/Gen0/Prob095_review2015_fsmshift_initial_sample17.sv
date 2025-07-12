module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam SHIFT_ENA = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT_ENA;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            IDLE: begin
                // In IDLE state, do nothing, just wait for reset
                shift_ena <= 1'b0;
            end
            SHIFT_ENA: begin
                // In SHIFT_ENA state, increment counter and check if 4 cycles have passed
                if (counter == 2'b11) begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1'b1;
                    shift_ena <= 1'b1;
                end
            end
        endcase
    end
end

endmodule