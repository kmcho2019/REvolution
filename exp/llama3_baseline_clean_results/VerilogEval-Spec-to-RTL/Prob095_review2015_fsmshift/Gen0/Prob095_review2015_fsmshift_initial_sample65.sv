module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state;
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // Start enabling shift register
        counter <= 2'b00; // Reset counter
        shift_ena <= 1'b1; // Enable shift register
    end else begin
        case (state)
            2'b01: begin // Enable shift register
                if (counter == 4'b100) begin
                    state <= 2'b00; // Stop enabling shift register
                    shift_ena <= 1'b0; // Disable shift register
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            2'b00: begin // Disable shift register
                shift_ena <= 1'b0; // Keep shift register disabled
            end
            default: begin
                state <= 2'b00; // Default state: disable shift register
                shift_ena <= 1'b0; // Disable shift register
            end
        endcase
    end
end

endmodule