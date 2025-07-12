module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using one-hot encoding
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// State register
reg [5:0] currentState;

// Combinational logic block
always @(*) begin
    case (currentState)
        A: begin
            if (w) begin
                currentState <= A;
                z <= 0;
            end else begin
                currentState <= B;
                z <= 0;
            end
        end
        B: begin
            if (w) begin
                currentState <= D;
                z <= 0;
            end else begin
                currentState <= C;
                z <= 0;
            end
        end
        C: begin
            if (w) begin
                currentState <= D;
                z <= 0;
            end else begin
                currentState <= E;
                z <= 0;
            end
        end
        D: begin
            if (w) begin
                currentState <= A;
                z <= 0;
            end else begin
                currentState <= F;
                z <= 0;
            end
        end
        E: begin
            if (w) begin
                currentState <= D;
                z <= 1;
            end else begin
                currentState <= E;
                z <= 1;
            end
        end
        F: begin
            if (w) begin
                currentState <= D;
                z <= 1;
            end else begin
                currentState <= C;
                z <= 1;
            end
        end
        default: begin
            currentState <= A;
            z <= 0;
        end
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else begin
        // No need to update currentState here, as it's handled by the combinational logic block
    end
end

endmodule