module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
reg [31:0] accumulator = 32'd0;
reg [31:0] result = 32'd0;
reg [31:0] count = 32'd0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'd0;
        accumulator <= 32'd0;
        result <= 32'd0;
        count <= 32'd0;
        z <= 1'd0;
    end else begin
        case (state)
            2'd0: begin // idle state
                state <= 2'd1;
            end
            2'd1: begin // accumulating state
                if (x == 1'd1) begin
                    accumulator[count] <= 1'd1;
                end
                count <= count + 1;
                if (areset) begin
                    state <= 2'd2;
                end
            end
            2'd2: begin // inverting state
                result[count - 1] <= ~accumulator[count - 1];
                if (count == 32'd1) begin
                    state <= 2'd3;
                end else begin
                    count <= count - 1;
                end
            end
            2'd3: begin // adding 1 state
                if (result[0] == 1'd0) begin
                    result[0] <= 1'd1;
                end else begin
                    result[0] <= 1'd0;
                    for (int i = 1; i < 32; i++) begin
                        if (result[i] == 1'd0) begin
                            result[i] <= 1'd1;
                            break;
                        end else begin
                            result[i] <= 1'd0;
                        end
                    end
                end
                state <= 2'd0;
            end
        endcase
    end
end

always @(posedge clk) begin
    case (state)
        2'd1: begin
            z <= 1'd0;
        end
        2'd2: begin
            z <= result[count];
        end
        2'd3: begin
            z <= result[0];
        end
        default: begin
            z <= 1'd0;
        end
    endcase
end

endmodule