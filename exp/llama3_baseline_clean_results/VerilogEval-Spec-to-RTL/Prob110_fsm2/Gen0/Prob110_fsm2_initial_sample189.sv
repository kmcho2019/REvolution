module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // Using [0:0] for a single bit to match common Verilog practice
parameter OFF = 1'b0, ON = 1'b1;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if(j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if(k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF;
        endcase
    end
end

always @(*) begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule