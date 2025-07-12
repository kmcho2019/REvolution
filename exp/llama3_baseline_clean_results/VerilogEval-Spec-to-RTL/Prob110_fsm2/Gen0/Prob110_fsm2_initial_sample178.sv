module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state; // Using 2 bits to represent the 2 states (OFF and ON)
parameter OFF = 2'b00, ON = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= OFF;
    end else begin
        case (state)
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
        endcase
    end
end

always @(*) begin
    case (state)
        OFF: out <= 1'b0;
        ON: out <= 1'b1;
    endcase
end

endmodule