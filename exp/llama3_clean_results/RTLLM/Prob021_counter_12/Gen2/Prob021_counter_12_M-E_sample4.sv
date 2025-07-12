module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

reg [3:0] count;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // IDLE state
        count <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (valid_count) begin
                    state <= 2'b01; // transition to COUNTING state
                end
                count <= 4'b0000;
            end
            2'b01: begin // COUNTING state
                if (count == 4'd11) begin
                    count <= 4'b0000;
                end else begin
                    count <= count + 1'b1;
                end
                if (!valid_count) begin
                    state <= 2'b00; // transition back to IDLE state
                end
            end
            default: begin
                state <= 2'b00; // default to IDLE state
                count <= 4'b0000;
            end
        endcase
    end
end

always @(*) begin
    if (state == 2'b01) begin
        out = count;
    end else begin
        out = 4'b0000;
    end
end

endmodule