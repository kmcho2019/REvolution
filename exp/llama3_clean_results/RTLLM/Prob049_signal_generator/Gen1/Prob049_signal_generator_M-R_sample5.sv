module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // state register
reg [4:0] next_wave; // next value of wave

// Combinational logic to determine next state and next wave
always @ (*) begin
    case (state)
        0: begin
            next_wave = wave + 1;
            if (wave == 31) begin
                state <= 1;
            end else begin
                state <= 0;
            end
        end
        1: begin
            next_wave = wave - 1;
            if (wave == 0) begin
                state <= 0;
            end else begin
                state <= 1;
            end
        end
        default: begin
            next_wave = 0;
            state <= 0;
        end
    endcase
end

// Sequential logic to update wave based on next_wave and reset
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        wave <= 0;
        state <= 0;
    end else begin
        wave <= next_wave;
    end
end

endmodule