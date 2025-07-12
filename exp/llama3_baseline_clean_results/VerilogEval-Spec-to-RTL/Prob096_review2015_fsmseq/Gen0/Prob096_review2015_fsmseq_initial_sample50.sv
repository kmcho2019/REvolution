module TopModule (
    input           clk,
    input           reset,
    input           data,
    output reg      start_shifting
);

reg [1:0] state;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;
localparam S4 = 2'b12;

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end
    else begin
        case (state)
            S0: if (data) begin
                state <= S1;
            end
            S1: if (data) begin
                state <= S2;
            end
            else begin
                state <= S0;
            end
            S2: if (~data) begin
                state <= S3;
            end
            else begin
                state <= S1;
            end
            S3: if (data) begin
                state <= S4;
            end
            else begin
                state <= S0;
            end
            default: ; // do nothing
        endcase

        if (state == S4) begin
            start_shifting <= 1;
        end
    end
end

endmodule