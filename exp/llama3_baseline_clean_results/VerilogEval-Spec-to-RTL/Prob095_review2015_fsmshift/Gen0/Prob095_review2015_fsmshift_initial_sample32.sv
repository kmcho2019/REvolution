module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 2 states: IDLE (0), SHIFT (1)
reg [1:0] counter; // counter to keep track of clock cycles

localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT_MAX = 2'b11; // 3 in decimal, 4 cycles - 1

always @(posedge clk) begin
    if(reset) begin // reset is active high
        state <= SHIFT;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case(state)
            IDLE: begin
                shift_ena <= 1'b0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if(counter == COUNT_MAX) begin
                    state <= IDLE;
                    counter <= 2'b00;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
        endcase
    end
end

endmodule