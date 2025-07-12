module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // 0 - OFF, 1 - ON
localparam OFF = 1'b0;
localparam ON = 1'b1;

always @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if(j) begin
                    state <= ON;
                end
            end
            ON: begin
                if(k) begin
                    state <= OFF;
                end
            end
            default: state <= OFF;
        endcase
    end
end

always @(*) begin
    case(state)
        OFF: out <= 1'b0;
        ON: out <= 1'b1;
        default: out <= 1'b0;
    endcase
end

endmodule