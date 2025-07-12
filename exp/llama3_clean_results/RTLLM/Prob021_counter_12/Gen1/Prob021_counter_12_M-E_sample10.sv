module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

reg [3:0] counter;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam COUNTING = 2'b01;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        counter <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                if (valid_count) begin
                    state <= COUNTING;
                    counter <= 4'b0000;
                end else begin
                    state <= IDLE;
                    counter <= 4'b0000;
                end
            end
            COUNTING: begin
                if (counter == 4'd11) begin
                    counter <= 4'b0000;
                end else begin
                    counter <= counter + 1'b1;
                end
                if (!valid_count) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign out = counter;

endmodule