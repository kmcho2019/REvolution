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
                if (counter == 31) begin
                    counter <= 31;
                    dir <= 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            1: begin
                if (counter == 0) begin
                    counter <= 0;
                    dir <= 0;
                end else begin
                    counter <= counter - 1;
                end
            end
        endcase
    end
end

assign wave = counter;

endmodule