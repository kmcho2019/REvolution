module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;
parameter E1 = 4'b1000; // g = 1
parameter E0 = 4'b1001; // g = 0

reg [1:0] state;
reg [1:0] nextState;
reg [3:0] stateE;
reg [3:0] nextStateE;
reg fReg;
reg gReg;
reg [1:0] xCount;
reg [1:0] yCount;

// Initialize outputs
assign f = fReg;
assign g = gReg;

// State register
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        stateE <= 0;
        xCount <= 0;
        yCount <= 0;
        fReg <= 0;
        gReg <= 0;
    end else begin
        state <= nextState;
        stateE <= nextStateE;
        xCount <= xCount + 1;
        yCount <= yCount + 1;
        fReg <= 0;
        gReg <= gReg;
    end
end

// Next state logic
always @(*) begin
    case(state)
        A: begin
            if (resetn) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            fReg = 1;
            nextState = C;
            xCount = 0;
        end
        C: begin
            if (x) begin
                xCount = xCount + 1;
            end else begin
                xCount = 0;
            end
            if (xCount == 3) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        D: begin
            if (y) begin
                nextStateE = E1;
                nextState = 0;
            end else if (yCount == 2) begin
                nextStateE = E0;
                nextState = 0;
            end else begin
                nextState = D;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

// E state logic
always @(*) begin
    case(stateE)
        E1: begin
            gReg = 1;
            nextState = 0;
            nextStateE = E1;
        end
        E0: begin
            gReg = 0;
            nextState = 0;
            nextStateE = E0;
        end
        default: begin
            nextStateE = 0;
        end
    endcase
end

endmodule