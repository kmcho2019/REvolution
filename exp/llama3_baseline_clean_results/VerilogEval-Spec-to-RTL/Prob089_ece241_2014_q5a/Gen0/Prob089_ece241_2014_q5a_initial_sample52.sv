module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0 - idle, 1 - running
reg invert; // flag to invert bits
reg [1:0] count; // counter to keep track of bits

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        invert <= 0;
        count <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (!areset) begin
                    state <= 1;
                    count <= 0;
                end
            end
            1: begin // running state
                if (areset) begin
                    state <= 0;
                end else begin
                    if (x) begin
                        invert <= 1;
                    end
                    if (invert) begin
                        z <= ~x;
                    end else begin
                        z <= x;
                    end
                    count <= count + 1;
                end
            end
        endcase
    end
end

endmodule