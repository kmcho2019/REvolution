module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

typedef enum reg [1:0] {A=2'b00, B=2'b01, C=2'b10, D=2'b11} state_t;

reg [1:0] state, next_state;

always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else begin
        state <= next_state;
        g <= 3'b000; // default, will be overridden below
    end
end

always @(*) begin
    next_state = state;
    g = 3'b000;  // default output
    
    case(state)
        A: begin
            // Priority: r[0] > r[1] > r[2]
            if (r[0]) begin
                next_state = B;
                g = 3'b001;
            end
            else if (r[1]) begin
                next_state = C;
                g = 3'b010;
            end
            else if (r[2]) begin
                next_state = D;
                g = 3'b100;
            end
            else begin
                next_state = A;
                g = 3'b000;
            end
        end
        B: begin
            g = 3'b001;
            next_state = (r[0]) ? B : A;
        end
        C: begin
            g = 3'b010;
            next_state = (r[1]) ? C : A;
        end
        D: begin
            g = 3'b100;
            next_state = (r[2]) ? D : A;
        end
        default: begin
            next_state = A;
            g = 3'b000;
        end
    endcase
end

endmodule