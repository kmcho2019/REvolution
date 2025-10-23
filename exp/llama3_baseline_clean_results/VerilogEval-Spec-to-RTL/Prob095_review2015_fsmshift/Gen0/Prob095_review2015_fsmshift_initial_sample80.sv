module TopModule(
    input clk,
    input reset,
    output reg shift_ena,
    input pattern_detected
);

reg [1:0] state;
reg [1:0] counter;

localparam IDLE = 2'b00;
localparam SHIFTING = 2'b01;

always @(posedge clk) begin
    if(reset) begin
        shift_ena <= 1'b1;
        counter <= 2'b00;
        state <= SHIFTING;
    end else if(state == IDLE) begin
        if(pattern_detected) begin
            shift_ena <= 1'b1;
            counter <= 2'b00;
            state <= SHIFTING;
        end else begin
            shift_ena <= 1'b0;
        end
    end else if(state == SHIFTING) begin
        shift_ena <= 1'b1;
        counter <= counter + 1'b1;
        if(counter == 4'b100) begin
            shift_ena <= 1'b0;
            state <= IDLE;
        end
    end
end

endmodule