module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] current_state;
localparam OFF = 1'b0;
localparam ON = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: begin
                if (j)
                    current_state <= ON;
                else
                    current_state <= OFF;
            end
            ON: begin
                if (k)
                    current_state <= OFF;
                else
                    current_state <= ON;
            end
        endcase
    end
end

always @(current_state) begin
    case (current_state)
        OFF: out <= 0;
        ON: out <= 1;
    endcase
end

endmodule