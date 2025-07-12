module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
        z <= 0;
    end else begin
        case (state)
            S0: begin
                if (x) begin
                    state <= S1;
                    z <= 0;
                end else begin
                    state <= S0;
                    z <= 0;
                end
            end
            S1: begin
                if (!x) begin
                    state <= S2;
                    z <= 0;
                end else begin
                    state <= S1;
                    z <= 0;
                end
            end
            S2: begin
                if (x) begin
                    state <= S1;
                    z <= 1;
                end else begin
                    state <= S0;
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule