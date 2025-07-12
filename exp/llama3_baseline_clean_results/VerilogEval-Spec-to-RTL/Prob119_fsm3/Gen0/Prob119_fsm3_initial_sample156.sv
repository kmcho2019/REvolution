module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        A: begin
            if (in == 0) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
            out <= 0;
        end
        B: begin
            if (in == 0) begin
                next_state <= C;
            end else begin
                next_state <= B;
            end
            out <= 0;
        end
        C: begin
            if (in == 0) begin
                next_state <= A;
            end else begin
                next_state <= D;
            end
            out <= 0;
        end
        D: begin
            if (in == 0) begin
                next_state <= C;
            end else begin
                next_state <= B;
            end
            out <= 1;
        end
    endcase
end

endmodule