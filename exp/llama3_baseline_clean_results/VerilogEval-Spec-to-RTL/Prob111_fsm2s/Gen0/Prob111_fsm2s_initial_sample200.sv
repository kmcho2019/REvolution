module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg current_state;

always @(posedge clk or posedge reset) begin
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
            default: current_state <= OFF;
        endcase
    end
end

assign out = current_state;

endmodule