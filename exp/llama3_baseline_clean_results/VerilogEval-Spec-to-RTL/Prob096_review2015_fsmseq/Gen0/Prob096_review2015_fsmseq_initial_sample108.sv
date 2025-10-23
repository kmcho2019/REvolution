module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 2 bits to represent 4 states
parameter IDLE = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if(data == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if(data == 1'b1) begin
                    state <= S2;
                end else if(data == 1'b0) begin
                    state <= IDLE;
                end
            end
            S2: begin
                if(data == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if(data == 1'b1) begin
                    state <= IDLE;
                end else begin
                    state <= IDLE;
                    start_shifting <= 1'b1;
                end
            end
        endcase
    end
end

endmodule