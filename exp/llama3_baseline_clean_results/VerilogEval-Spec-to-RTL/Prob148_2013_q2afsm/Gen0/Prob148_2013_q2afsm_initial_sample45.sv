module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define the state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

reg [1:0] state, next_state;

// Describe the state transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else if (r[1] == 1'b1) begin
                next_state <= C;
            end else if (r[2] == 1'b1) begin
                // State D is not needed, so we will go to A
                next_state <= A;
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
        default: next_state <= A;
    endcase
end

// Describe the output g[i]
assign g[0] = (state == B)? 1'b1 : 1'b0;
assign g[1] = (state == C)? 1'b1 : 1'b0;
assign g[2] = 1'b0;

endmodule