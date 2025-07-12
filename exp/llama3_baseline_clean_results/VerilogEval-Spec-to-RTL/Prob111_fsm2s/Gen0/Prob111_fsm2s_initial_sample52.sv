module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // 2 states, so we need 2 bits (00 for OFF, 01 for ON)
parameter OFF = 2'b00;
parameter ON = 2'b01;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        case(state)
            OFF: begin
                if(j) begin
                    state <= ON;
                    out <= 1'b1;
                end else begin
                    state <= OFF;
                    out <= 1'b0;
                end
            end
            ON: begin
                if(k) begin
                    state <= OFF;
                    out <= 1'b0;
                end else begin
                    state <= ON;
                    out <= 1'b1;
                end
            end
        endcase
    end
end

endmodule