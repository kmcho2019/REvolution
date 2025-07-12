module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Start first cycle
        end else begin
            case (state)
                4'b0001: state <= 4'b0010;  // Cycle 1 → 2
                4'b0010: state <= 4'b0100;  // Cycle 2 → 3
                4'b0100: state <= 4'b1000;  // Cycle 3 → 4
                4'b1000: state <= 4'b0000;  // Cycle 4 → stop
                default: state <= 4'b0000;  // Maintain zeros
            endcase
        end
    end

    assign shift_ena = |state;  // High when any state bit is set

endmodule