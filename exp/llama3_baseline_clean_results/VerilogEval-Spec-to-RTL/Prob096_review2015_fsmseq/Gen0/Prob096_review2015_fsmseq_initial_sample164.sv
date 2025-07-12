module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state;

localparam Idle = 2'b00;
localparam S1   = 2'b01;
localparam S2   = 2'b10;
localparam S3   = 2'b11;
localparam Found = 2'b10; // The same as S2 to reuse the logic and remain in Found state

always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        case (state)
            Idle: begin
                if (data) begin
                    state <= S1;
                end else begin
                    state <= Idle;
                end
                start_shifting <= 0;
            end
            S1: begin
                if (data) begin
                    state <= S2;
                end else begin
                    state <= Idle;
                end
                start_shifting <= 0;
            end
            S2: begin
                if (!data) begin
                    state <= S3;
                end else begin
                    state <= Idle;
                end
                start_shifting <= 0;
            end
            S3: begin
                if (data) begin
                    state <= Found;
                end else begin
                    state <= Idle;
                end
                start_shifting <= 0;
            end
            Found: begin
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule