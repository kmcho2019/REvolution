module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state = 2'b00; // 2 states, so 2 bits (00 for OFF, 01 for ON)

localparam OFF = 2'b00;
localparam ON = 2'b01;

always @ (posedge clk or posedge areset) begin
    if (areset) begin // asynchronous reset to OFF state
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF; // default to OFF if state is unknown
        endcase
    end
end

always @(*) begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0; // default output to 0 if state is unknown
    endcase
end

endmodule