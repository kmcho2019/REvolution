`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 0;
    end else begin
        case (currentState)
            0: currentState <= w ? 0 : 1;
            1: currentState <= w ? 3 : 2;
            2: currentState <= w ? 3 : 4;
            3: currentState <= w ? 0 : 5;
            4, 5: currentState <= w ? 3 : (currentState == 4) ? 4 : 2;
            default: currentState <= 0;
        endcase
    end
end

// Output z logic
reg output_condition;
always @(posedge clk) begin
    if (reset) begin
        output_condition <= 0;
    end else begin
        case (currentState)
            4, 5: output_condition <= 1;
            default: output_condition <= 0;
        endcase
    end
end
assign z = output_condition;

endmodule