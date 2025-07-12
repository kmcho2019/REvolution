module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        A: begin
            if (~in) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        B: begin
            if (~in) begin
                next_state <= C;
            end else begin
                next_state <= B;
            end
        end
        C: begin
            if (~in) begin
                next_state <= A;
            end else begin
                next_state <= D;
            end
        end
        D: begin
            if (~in) begin
                next_state <= C;
            end else begin
                next_state <= B;
            end
        end
        default: begin
            next_state <= A;
        end
    endcase
end

always @(*) begin
    case(current_state)
        A: out <= 1'b0;
        B: out <= 1'b0;
        C: out <= 1'b0;
        D: out <= 1'b1;
        default: out <= 1'b0;
    endcase
end

endmodule