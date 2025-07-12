module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg increment;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        increment <= 1;
    end else begin
        if (increment) begin
            if (counter == 31) begin
                counter <= 31;
                increment <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            if (counter == 0) begin
                counter <= 0;
                increment <= 1;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

assign wave = counter;

endmodule