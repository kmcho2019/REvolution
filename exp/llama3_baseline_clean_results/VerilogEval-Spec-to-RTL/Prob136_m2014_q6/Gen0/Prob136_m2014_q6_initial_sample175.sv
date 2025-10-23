module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;

// Define the states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

always @(*) begin
    case (currentState)
        A: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        C: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        D: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = F;
            end
        end
        E: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        F: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        default: nextState = A;
    endcase
end

assign z = (currentState == E || currentState == F)? 1'b1 : 1'b0;

endmodule