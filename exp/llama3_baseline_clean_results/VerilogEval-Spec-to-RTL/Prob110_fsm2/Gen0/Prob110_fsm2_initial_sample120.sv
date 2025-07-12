module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

localparam OFF = 1'b0;
localparam ON = 1'b1;
reg current_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
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

always @(current_state) begin
    case(current_state)
        OFF: out <= 1'b0;
        ON: out <= 1'b1;
    endcase
end

endmodule