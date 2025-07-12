module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        direction <= 0;
    end else begin
        case (direction)
            1'b0: begin
                if (counter == 5'd31) begin
                    counter <= 5'd31;
                    direction <= 1'b1;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            1'b1: begin
                if (counter == 5'd0) begin
                    counter <= 5'd0;
                    direction <= 1'b0;
                end else begin
                    counter <= counter - 1'b1;
                end
            end
        endcase
    end
end

assign wave = counter;

endmodule