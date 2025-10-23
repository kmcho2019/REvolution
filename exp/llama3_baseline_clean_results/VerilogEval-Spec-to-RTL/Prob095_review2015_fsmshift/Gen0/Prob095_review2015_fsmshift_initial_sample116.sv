module TopModule (
    input           clk,
    input           reset,
    output          shift_ena
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam SHIFT_ENABLE = 2'b01;
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT_ENABLE;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            IDLE: begin
                shift_ena <= 1'b0;
            end
            SHIFT_ENABLE: begin
                if (counter == 2'b11) begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1;
                    shift_ena <= 1'b1;
                end
            end
        endcase
    end
end

endmodule