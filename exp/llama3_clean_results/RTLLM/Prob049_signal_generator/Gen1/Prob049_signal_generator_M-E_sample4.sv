module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

parameter DIR = 1; // initial direction (1 for increment, 0 for decrement)
parameter MAX_VALUE = 31; // maximum value of the waveform

reg [4:0] count; // counter
reg dir; // direction of the counter (1 for increment, 0 for decrement)

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        count <= 0;
        dir <= DIR;
    end else begin
        if (dir) begin // incrementing
            count <= count + 1;
            if (count == MAX_VALUE) begin // change direction when reaching maximum value
                dir <= 0;
            end
        end else begin // decrementing
            count <= count - 1;
            if (count == 0) begin // change direction when reaching minimum value
                dir <= 1;
            end
        end
    end
end

assign wave = count;

endmodule