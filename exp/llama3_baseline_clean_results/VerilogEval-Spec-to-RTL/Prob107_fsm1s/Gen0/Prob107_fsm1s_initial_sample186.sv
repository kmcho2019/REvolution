module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

parameter B = 2'b00;
parameter A = 2'b01;

reg [1:0] current_state;
reg [1:0] next_state;

always @ (posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    case (current_state)
        B: begin
            if (!in) begin
                next_state <= A;
                out <= 1'b1;
            end else begin
                next_state <= B;
                out <= 1'b1;
            end
        end
        A: begin
            if (!in) begin
                next_state <= B;
                out <= 1'b0;
            end else begin
                next_state <= A;
                out <= 1'b0;
            end
        end
        default: begin
            next_state <= B;
            out <= 1'b1;
        end
    endcase
end

endmodule