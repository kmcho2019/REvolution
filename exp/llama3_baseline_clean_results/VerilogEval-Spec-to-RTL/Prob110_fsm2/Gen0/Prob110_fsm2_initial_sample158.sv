module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // Define the state as a 1-bit reg
parameter OFF = 1'b0, ON = 1'b1;

always @(posedge clk or posedge areset) begin
    if(areset) begin // Asynchronous reset to OFF
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
            default: state <= OFF; // Default to OFF for invalid states
        endcase
    end
end

endmodule