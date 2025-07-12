module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // 2-bit state register
localparam S0 = 2'b00; // State 0: Initial state
localparam S1 = 2'b01; // State 1: '1' detected
localparam S2 = 2'b10; // State 2: '01' detected

always @(*) begin
    if (!aresetn) begin
        state <= S0; // Asynchronous reset
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
                if (x) begin
                    state <= S1;
                end else begin
                    state <= S2;
                end
            end
            S2: begin
                if (x) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    case (state)
        S0: begin
            z <= 0;
        end
        S1: begin
            z <= 0;
        end
        S2: begin
            if (x) begin
                z <= 1;
            end else begin
                z <= 0;
            end
        end
    endcase
end

endmodule