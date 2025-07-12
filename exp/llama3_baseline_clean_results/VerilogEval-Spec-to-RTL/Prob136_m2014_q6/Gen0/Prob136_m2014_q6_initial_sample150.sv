module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;
reg [2:0] nextState;

always @(*) begin
    case(currentState)
        3'b000: begin // State A
            if(w) begin
                nextState = 3'b000; // Stay in A
                z = 1'b0;
            end else begin
                nextState = 3'b001; // Go to B
                z = 1'b0;
            end
        end
        3'b001: begin // State B
            if(w) begin
                nextState = 3'b011; // Go to D
                z = 1'b0;
            end else begin
                nextState = 3'b010; // Go to C
                z = 1'b0;
            end
        end
        3'b010: begin // State C
            if(w) begin
                nextState = 3'b011; // Go to D
                z = 1'b0;
            end else begin
                nextState = 3'b100; // Go to E
                z = 1'b0;
            end
        end
        3'b011: begin // State D
            if(w) begin
                nextState = 3'b000; // Go to A
                z = 1'b0;
            end else begin
                nextState = 3'b101; // Go to F
                z = 1'b0;
            end
        end
        3'b100: begin // State E
            if(w) begin
                nextState = 3'b011; // Go to D
                z = 1'b1;
            end else begin
                nextState = 3'b100; // Stay in E
                z = 1'b1;
            end
        end
        3'b101: begin // State F
            if(w) begin
                nextState = 3'b011; // Go to D
                z = 1'b1;
            end else begin
                nextState = 3'b010; // Go to C
                z = 1'b1;
            end
        end
        default: begin
            nextState = 3'b000; // Reset to A
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        currentState <= 3'b000; // Reset to A
    end else begin
        currentState <= nextState;
    end
end

endmodule