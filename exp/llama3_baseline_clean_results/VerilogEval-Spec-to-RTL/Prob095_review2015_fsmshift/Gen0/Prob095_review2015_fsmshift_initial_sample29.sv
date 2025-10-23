module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter; // 2-bit counter to count 4 cycles
reg [1:0] state; // 2-state FSM: 0 - idle, 1 - shifting
localparam IDLE = 2'b00;
localparam SHIFTING = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFTING;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            IDLE: begin
                shift_ena <= 1'b0;
            end
            SHIFTING: begin
                shift_ena <= 1'b1;
                if (counter == 4'd3) begin
                    state <= IDLE;
                end else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end
end

endmodule