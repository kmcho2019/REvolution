module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the states as an enumeration
enum logic [1:0] {
    A,
    B,
    C,
    D
} current_state, next_state;

// Always block for state table and state flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (r[0]) begin
                    current_state <= B;
                end else if (r[1]) begin
                    current_state <= C;
                end else if (r[2]) begin
                    current_state <= D;
                end else begin
                    current_state <= A;
                end
            end
            B: begin
                if (r[0]) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            C: begin
                if (r[1]) begin
                    current_state <= C;
                end else begin
                    current_state <= A;
                end
            end
            D: begin
                if (r[2]) begin
                    current_state <= D;
                end else begin
                    current_state <= A;
                end
            end
        endcase
    end
end

// Always block for outputs g[2:0]
always @(current_state) begin
    case (current_state)
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
    endcase
end

endmodule