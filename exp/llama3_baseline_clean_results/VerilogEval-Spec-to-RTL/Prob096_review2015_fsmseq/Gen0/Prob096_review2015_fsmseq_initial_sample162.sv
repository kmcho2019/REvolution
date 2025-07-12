module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3 bits for 6 states ( Idle = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, Found = 3'b101 )
localparam Idle = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, Found = 3'b101;

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= Idle;
        start_shifting <= 0;
    end else begin
        case(state)
            Idle: begin
                if(data)
                    state <= S1;
            end
            S1: begin
                if(data)
                    state <= S2;
                else
                    state <= Idle;
            end
            S2: begin
                if(!data)
                    state <= S3;
                else
                    state <= S1;
            end
            S3: begin
                if(data)
                    state <= S4;
                else
                    state <= Idle;
            end
            S4: begin
                if(data)
                    state <= Found;
                else
                    state <= Idle;
            end
            Found: begin // Stay in Found state once reached
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule