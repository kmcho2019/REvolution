`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;

// State transition and output z logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= 0;
        z <= 0;
    end else begin
        case (currentState)
            0: begin
                currentState <= w? 0 : 1;
                z <= 0;
            end
            1: begin
                currentState <= w? 3 : 2;
                z <= 0;
            end
            2: begin
                currentState <= w? 3 : 4;
                z <= 0;
            end
            3: begin
                currentState <= w? 0 : 5;
                z <= 0;
            end
            4: begin
                currentState <= w? 3 : 4;
                z <= 1;
            end
            5: begin
                currentState <= w? 3 : 2;
                z <= 1;
            end
            default: begin
                currentState <= 0;
                z <= 0;
            end
        endcase
    end
end

endmodule