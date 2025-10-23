module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        dir <= 0;
    end else begin
        case (dir)
            0: begin
                counter <= (counter == 31) ? 0 : counter + 1;
                if (counter == 31) dir <= 1;
            end
            1: begin
                counter <= (counter == 0) ? 31 : counter - 1;
                if (counter == 0) dir <= 0;
            end
        endcase
    end
end

assign wave = counter;

endmodule