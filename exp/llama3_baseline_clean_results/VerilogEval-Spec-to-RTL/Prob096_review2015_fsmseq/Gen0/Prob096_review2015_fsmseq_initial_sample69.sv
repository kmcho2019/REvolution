module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 2 bits to represent 4 states (IDLE, S1, S2, S3, S4)
localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;
localparam S4 = 2'b12; // note: this value is outside the 2-bit range, 
                        // but we only use it to set start_shifting to 1

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data == 1'b1) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (data == 1'b1) begin
                    state <= IDLE; // we use S4 as a flag, not as a state
                    start_shifting <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule