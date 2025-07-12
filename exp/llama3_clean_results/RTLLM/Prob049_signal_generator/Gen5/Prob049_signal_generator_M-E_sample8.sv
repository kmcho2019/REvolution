module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [7:0] phase_accumulator;
reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_accumulator <= 0;
        direction <= 1;
    end else begin
        if (direction == 1) begin
            phase_accumulator <= phase_accumulator + 1;
            if (phase_accumulator == 255) begin
                phase_accumulator <= 255;
                direction <= 0;
            end
        end else begin
            phase_accumulator <= phase_accumulator - 1;
            if (phase_accumulator == 0) begin
                phase_accumulator <= 0;
                direction <= 1;
            end
        end
    end
end

always @(*) begin
    if (direction == 1) begin
        wave = phase_accumulator[7:3];
    end else begin
        wave = ~(phase_accumulator[7:3]) + 1;
    end
end

endmodule