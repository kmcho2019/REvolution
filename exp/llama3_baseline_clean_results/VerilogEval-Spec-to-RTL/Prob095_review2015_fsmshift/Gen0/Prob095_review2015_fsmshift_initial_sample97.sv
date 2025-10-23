module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state;
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1;  // Shifting state
        counter <= 1'b0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            1'b1: begin  // Shifting state
                if (counter == 4'd3) begin
                    state <= 1'b0;  // Idle state
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1'b1;
                    shift_ena <= 1'b1;
                end
            end
            1'b0: begin  // Idle state
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule