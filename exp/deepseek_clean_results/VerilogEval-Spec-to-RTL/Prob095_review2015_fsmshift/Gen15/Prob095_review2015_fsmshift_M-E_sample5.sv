module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [4:0] state;  // One-hot: [4]=idle, [3:0]=active cycles

    // shift_ena is active when not in idle state
    assign shift_ena = ~state[4];

    always @(posedge clk) begin
        if (reset) begin
            state <= 5'b00001;  // Start with first active cycle
        end else begin
            case (state)
                5'b00001: state <= 5'b00010;  // Cycle 0 → 1
                5'b00010: state <= 5'b00100;  // Cycle 1 → 2
                5'b00100: state <= 5'b01000;  // Cycle 2 → 3
                5'b01000: state <= 5'b10000;  // Cycle 3 → idle
                default: state <= 5'b10000;   // Stay in idle
            endcase
        end
    end

endmodule