module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

parameter A = 1'b0;
parameter B = 1'b1;

reg current_state;
reg next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= B;
    end else begin
        case(current_state)
            A: begin
                if(in == 1'b0) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            B: begin
                if(in == 1'b0) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
        endcase
    end
end

always @(current_state) begin
    case(current_state)
        A: out <= 1'b0;
        B: out <= 1'b1;
    endcase
end

endmodule