module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT;
        counter <= 4'b0000;
        shift_ena <= 1'b1;
    end else begin
        case(state)
            IDLE: begin
                shift_ena <= 1'b0;
            end
            SHIFT: begin
                if (counter == 4'b100) begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
        endcase
    end
end

endmodule