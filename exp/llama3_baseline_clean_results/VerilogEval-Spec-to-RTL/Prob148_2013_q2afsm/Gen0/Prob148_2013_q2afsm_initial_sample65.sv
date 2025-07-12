module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define current and next state signals
reg [1:0] state, next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else if (r[1] == 1'b1) begin
                next_state <= C;
            end else if (r[2] == 1'b1) begin
                next_state <= D;
            end else begin
                next_state <= A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state <= C;
            end else begin
                next_state <= A;
            end
        end
        D: begin
            // According to the problem description, the next state for D is not specified.
            // We will assume that D should be treated the same as A in terms of priority.
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else if (r[1] == 1'b1) begin
                next_state <= C;
            end else if (r[2] == 1'b1) begin
                next_state <= D;
            end else begin
                next_state <= A;
            end
        end
        default: begin
            next_state <= A;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        A: begin
            g <= 3'b000;
        end
        B: begin
            g <= 3'b100;
        end
        C: begin
            g <= 3'b010;
        end
        D: begin
            g <= 3'b001;
        end
        default: begin
            g <= 3'b000;
        end
    endcase
end

endmodule