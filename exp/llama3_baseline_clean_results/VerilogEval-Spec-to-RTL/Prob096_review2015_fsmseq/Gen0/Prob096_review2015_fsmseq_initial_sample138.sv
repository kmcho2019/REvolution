module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3 bits to represent 6 states (0-5)
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101; // This state is not used but included for completeness

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        case (state)
            S0: begin
                if (data == 1) state <= S1;
                else state <= S0;
            end
            S1: begin
                if (data == 1) state <= S2;
                else state <= S0;
            end
            S2: begin
                if (data == 0) state <= S3;
                else state <= S1;
            end
            S3: begin
                if (data == 1) state <= S4;
                else state <= S0;
            end
            S4: begin
                start_shifting <= 1;
                state <= S4; // Absorbing state
            end
            default: state <= S0;
        endcase
    end
end

endmodule