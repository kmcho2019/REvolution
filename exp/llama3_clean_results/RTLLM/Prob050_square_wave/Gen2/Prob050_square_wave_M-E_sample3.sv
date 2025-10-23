module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;
reg [1:0] state; // 0: low, 1: high, 2: transition (not needed, simplification)

always @(posedge clk) begin
    case(state)
        0: begin // Low state
            if (count == freq - 1) begin
                count <= 0;
                state <= 1; // Transition to high state
            end else begin
                count <= count + 1;
            end
        end
        1: begin // High state
            if (count == freq - 1) begin
                count <= 0;
                state <= 0; // Transition to low state
            end else begin
                count <= count + 1;
            end
        end
        default: state <= 0; // Reset to low state if somehow in an invalid state
    endcase
end

always @(posedge clk) begin
    case(state)
        0: wave_out <= 0; // Low state
        1: wave_out <= 1; // High state
        default: wave_out <= 0; // Default to low if in an invalid state
    endcase
end

initial begin
    wave_out = 0;
    count = 0;
    state = 0;
end

endmodule