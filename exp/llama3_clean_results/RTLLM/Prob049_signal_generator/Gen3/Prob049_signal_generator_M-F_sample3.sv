module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [1:0] state; // state variable to control waveform generation
reg [4:0] count; // counter to generate waveform

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        state <= 0;
        count <= 0;
    end else begin
        case (state)
            0: begin // incrementing
                count <= count + 1;
                if (count == 31) begin // change state when reaching maximum value
                    state <= 1;
                end
            end
            1: begin // decrementing
                count <= count - 1;
                if (count == 0) begin // change state when reaching minimum value
                    state <= 0;
                end
            end
            default: begin
                state <= 0;
                count <= 0;
            end
        endcase
    end
end

assign wave = count;

endmodule