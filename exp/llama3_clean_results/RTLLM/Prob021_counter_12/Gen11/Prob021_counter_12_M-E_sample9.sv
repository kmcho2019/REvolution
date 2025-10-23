module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

reg [3:0] count;
reg [1:0] state; // 0: idle, 1: counting

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        count <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (valid_count) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                count <= 0;
            end
            1: begin // counting state
                if (valid_count) begin
                    if (count == 4'd11) begin
                        count <= 0;
                    end else begin
                        count <= count + 1;
                    end
                end else begin
                    state <= 0;
                end
            end
        endcase
    end
end

always @ (*) begin
    out = count;
end

endmodule