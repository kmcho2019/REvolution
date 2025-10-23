module TopModule(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] counter;
reg [1:0] state;

// Define states
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT;
        counter <= 0;
    end else if (state == SHIFT) begin
        if (counter == 3) begin
            state <= IDLE;
        end else begin
            counter <= counter + 1;
        end
    end else if (state == IDLE) begin
        // Do nothing
    end
end

always @(*) begin
    if (state == SHIFT) begin
        shift_ena = 1'b1;
    end else begin
        shift_ena = 1'b0;
    end
end

endmodule