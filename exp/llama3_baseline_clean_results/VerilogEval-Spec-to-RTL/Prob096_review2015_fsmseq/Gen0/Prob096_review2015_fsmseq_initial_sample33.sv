module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;

localparam Idle = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;
localparam Found = 2'b00; // reuse Idle state for Found

always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        case (state)
            Idle: begin
                if (data == 1) begin
                    state <= S1;
                end
            end
            S1: begin
                if (data == 1) begin
                    state <= S2;
                end else if (data == 0) begin
                    state <= Idle;
                end
            end
            S2: begin
                if (data == 0) begin
                    state <= S3;
                end else if (data == 1) begin
                    state <= S1;
                end
            end
            S3: begin
                if (data == 1) begin
                    state <= Found;
                    start_shifting <= 1;
                end else if (data == 0) begin
                    state <= Idle;
                end
            end
            Found: begin
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule