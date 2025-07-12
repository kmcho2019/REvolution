module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
reg [1:0] cnt;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        cnt <= 0;
    end else if (state == 0) begin
        if (x) begin
            state <= 1;
            cnt <= 1;
        end else begin
            state <= 0;
            cnt <= 0;
        end
    end else if (state == 1) begin
        state <= 2;
        cnt <= cnt + 1;
    end else if (state == 2) begin
        if (cnt == 1) begin
            state <= 3;
        end else begin
            state <= 2;
            cnt <= cnt + 1;
        end
    end else if (state == 3) begin
        state <= 0;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        z <= 0;
    end else if (state == 0) begin
        z <= x;
    end else if (state == 1) begin
        z <= ~x;
    end else if (state == 2) begin
        z <= ~x;
    end else if (state == 3) begin
        z <= 1;
    end
end

endmodule