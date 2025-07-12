module TopModule(
    input           clk,
    input           reset,
    output          shift_ena
);

reg [1:0] state;
reg [1:0] counter;

localparam IDLE = 2'b00;
localparam SHIFT_ENABLE = 2'b01;

always @(posedge clk) begin
    if(reset) begin
        state <= SHIFT_ENABLE;
        counter <= 2'b00;
    end else begin
        case(state)
            IDLE: begin
                shift_ena <= 1'b0;
                if(reset) begin
                    state <= SHIFT_ENABLE;
                    counter <= 2'b00;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT_ENABLE: begin
                shift_ena <= 1'b1;
                counter <= counter + 1;
                if(counter == 2'b11) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule