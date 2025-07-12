module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] current_state, next_state;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        A: begin
            if(!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if(!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        C: begin
            if(!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if(!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
    endcase
end

always @(*) begin
    case(current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule