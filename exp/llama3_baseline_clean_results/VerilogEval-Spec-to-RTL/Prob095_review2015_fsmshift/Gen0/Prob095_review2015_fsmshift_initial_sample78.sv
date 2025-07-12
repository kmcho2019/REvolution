module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2-bit state variable
reg [1:0] count; // 2-bit counter

// Define states
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter HOLD = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT;
        count <= 2'b01; // Initialize counter to 1
        shift_ena <= 1'b1;
    end else begin
        case (state)
            SHIFT: begin
                if (count == 4'b100) begin // Count reached 4
                    state <= HOLD;
                    shift_ena <= 1'b0;
                end else begin
                    count <= count + 1'b1;
                    shift_ena <= 1'b1;
                end
            end
            HOLD: begin
                shift_ena <= 1'b0;
            end
            IDLE: begin
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule