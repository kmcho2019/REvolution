module TopModule(
    input         clk,
    input         reset,
    input         w,
    output        z
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Declare current state and next state variables
reg [2:0] currentState;
reg [2:0] nextState;

// Declare output variable
reg z;

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Combinational logic for next state and output
always @(*) begin
    case(currentState)
        A: if(w) begin
            nextState = A;
            z = 0;
        end else begin
            nextState = B;
            z = 0;
        end
        B: if(w) begin
            nextState = D;
            z = 0;
        end else begin
            nextState = C;
            z = 0;
        end
        C: if(w) begin
            nextState = D;
            z = 0;
        end else begin
            nextState = E;
            z = 0;
        end
        D: if(w) begin
            nextState = A;
            z = 0;
        end else begin
            nextState = F;
            z = 0;
        end
        E: if(w) begin
            nextState = D;
            z = 1;
        end else begin
            nextState = E;
            z = 1;
        end
        F: if(w) begin
            nextState = D;
            z = 1;
        end else begin
            nextState = C;
            z = 1;
        end
        default: begin
            nextState = A;
            z = 0;
        end
    endcase
end

endmodule