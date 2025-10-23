module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 3 states: S0, S1, S2
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        case (state)
            S0: begin
                if (x) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (~x) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (x) begin
                    state <= S1;
                    z <= 1'b1;
                end else begin
                    state <= S0;
                end
            end
            default: state <= S0;
        endcase
    end
end

always @(*) begin
    if (state == S2 && x == 1'b1) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

endmodule