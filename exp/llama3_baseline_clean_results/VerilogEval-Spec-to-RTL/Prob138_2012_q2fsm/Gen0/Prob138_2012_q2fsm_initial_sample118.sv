module TopModule(
    input       clk,
    input       reset,
    input       w,
    output      z
);

// Define state codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define current and next state
reg [2:0] currentState;
reg [2:0] nextState;

// State flip-flops
always @(posedge clk) begin
    if(reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// State table
always @(*) begin
    case(currentState)
        A: begin
            if(w) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            if(w) begin
                nextState = C;
            end else begin
                nextState = D;
            end
        end
        C: begin
            if(w) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        D: begin
            if(w) begin
                nextState = F;
            end else begin
                nextState = A;
            end
        end
        E: begin
            if(w) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        F: begin
            if(w) begin
                nextState = C;
            end else begin
                nextState = D;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

// Output z
assign z = (currentState == E || currentState == F)? 1'b1 : 1'b0;

endmodule