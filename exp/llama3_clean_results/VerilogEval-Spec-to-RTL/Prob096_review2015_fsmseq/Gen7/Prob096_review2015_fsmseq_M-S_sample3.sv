module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] sequence_detector;

always @(posedge clk) begin
    if(reset) begin
        sequence_detector <= 4'b0000;
        start_shifting <= 0;
    end else begin
        sequence_detector <= {sequence_detector[2:0], data};
        if(sequence_detector == 4'b1101) begin
            start_shifting <= 1;
        end
    end
end

endmodule