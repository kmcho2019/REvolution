`timescale 1ns/1ps

module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
parameter B = 1'b0;
parameter A = 1'b1;

reg [0:0] currentState;
reg [0:0] nextState;

// Output logic
assign out = (currentState == B) ? 1'b1 : 1'b0;

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        currentState <= B;
    end else begin
        case(currentState)
            B: begin
                if(in == 1'b0) begin
                    currentState <= A;
                end else begin
                    currentState <= B;
                end
            end
            A: begin
                if(in == 1'b0) begin
                    currentState <= B;
                end else begin
                    currentState <= A;
                end
            end
            default: currentState <= B;
        endcase
    end
end

initial begin
    currentState <= B;
end

endmodule