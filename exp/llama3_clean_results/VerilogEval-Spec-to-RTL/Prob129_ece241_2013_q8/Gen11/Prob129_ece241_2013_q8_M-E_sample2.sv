module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // Gray code state encoding
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b11;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
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
                if (!x) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (x) begin
                    state <= S0;
                end else begin
                    state <= S2;
                end
            end
        endcase
    end
end

// Output logic
assign z = (state == S2) && x;

endmodule