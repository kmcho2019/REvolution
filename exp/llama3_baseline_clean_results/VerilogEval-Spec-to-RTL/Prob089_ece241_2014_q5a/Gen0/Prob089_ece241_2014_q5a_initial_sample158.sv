module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // 0: idle, 1: running, 2: inversion
reg inversion;
reg [1:0] nextState;

always @(*) begin
    case (state)
        0: begin // idle
            if (~areset) begin
                nextState = 1;
                inversion = 1'b0;
            end
            else begin
                nextState = 0;
                inversion = 1'b0;
            end
        end
        1: begin // running
            if (x) begin
                nextState = 2;
            end
            else begin
                nextState = 1;
            end
        end
        2: begin // inversion
            if (areset) begin
                nextState = 0;
            end
            else begin
                nextState = 2;
            end
        end
        default: begin
            nextState = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        z <= 1'b0;
    end
    else begin
        state <= nextState;
        if (state == 2) begin
            z <= ~x;
        end
        else if (state == 1) begin
            z <= x;
        end
        else begin
            z <= 1'b0;
        end
    end
end

endmodule