module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare the current state variable
reg [1:0] current_state;

// State flip-flops and state table
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

// Output logic
always @(*) begin
    case (current_state)
        A: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = r[2];
        end
        B: begin
            g[0] = 1'b1;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        C: begin
            g[0] = 1'b0;
            g[1] = 1'b1;
            g[2] = 1'b0;
        end
        D: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b1;
        end
    endcase
end

endmodule