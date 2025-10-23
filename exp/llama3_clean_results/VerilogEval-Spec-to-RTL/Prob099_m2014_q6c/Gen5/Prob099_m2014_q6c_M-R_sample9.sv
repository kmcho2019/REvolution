module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

reg [5:0] nextState;

always @(y, w) begin
    case (1'b1)
        y[0]: begin // State A
            if (~w) begin
                nextState = 6'b000010; // Transition to B on w=0
            end else begin
                nextState = 6'b000001; // Stay in A on w=1
            end
        end
        y[1]: begin // State B
            if (~w) begin
                nextState = 6'b000100; // Transition to C on w=0
            end else begin
                nextState = 6'b001000; // Transition to D on w=1
            end
        end
        y[2]: begin // State C
            if (~w) begin
                nextState = 6'b100000; // Transition to E on w=0
            end else begin
                nextState = 6'b001000; // Transition to D on w=1
            end
        end
        y[3]: begin // State D
            if (~w) begin
                nextState = 6'b100000; // Transition to F on w=0
            end else begin
                nextState = 6'b000001; // Transition to A on w=1
            end
        end
        y[4]: begin // State E
            if (w) begin
                nextState = 6'b100000; // Stay in E on w=1
            end else begin
                nextState = 6'b001000; // Transition to D on w=0
            end
        end
        y[5]: begin // State F
            if (w) begin
                nextState = 6'b000100; // Transition to C on w=1
            end else begin
                nextState = 6'b001000; // Transition to D on w=0
            end
        end
        default: begin
            nextState = 6'b000001; // Default to State A
        end
    endcase
end

assign Y1 = nextState[1];
assign Y3 = nextState[3];

endmodule