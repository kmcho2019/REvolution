module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] current_state;
parameter OFF = 1'b0;
parameter ON = 1'b1;

always @ (posedge clk) begin
    if(reset) begin
        current_state <= OFF;
    end else begin
        case(current_state)
            OFF: begin
                if(j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if(k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
        endcase
    end
end

always @ (*) begin
    case(current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
    endcase
end

endmodule